extends Node
class_name Visualizer_Solver

const center:Vector2 = Vector2.ZERO
var ordenando:bool = false

func obtener_rotacion(pos_actual:Vector2) -> float:
	var angulo:float
	angulo = (pos_actual - center).angle()
	
	return angulo
	
func obtener_vector_radial(angulo: float) -> Vector2:
	return Vector2(cos(angulo), sin(angulo))

func reordenar_fichas_visualmente(casilla: Casilla) -> void:
	if ordenando:
		return
	
	ordenando = true
	var angulo := casilla.global_rotation
	var dir := obtener_vector_radial(angulo)

	for i in range(casilla.fichas.size()):
		var ficha := casilla.fichas[i]
		ficha.global_rotation = casilla.global_rotation
		ficha.z_index = i + 3
		ficha.global_position = casilla.global_position + dir * (i * 5)
	
	ordenando = false
			
#region animaciones movimiento

func animar_ficha_move(ficha:FichaEstandar,
destino: Casilla, animable:Animable) -> void:
	
	var dir:= obtener_vector_radial(ficha.global_rotation)
	var offset:= dir * (destino.fichas.size() * 5)
	
	var pos_inicio := ficha.global_position
	var pos_fin := destino.global_position + offset
	var rot_inicio := ficha.global_rotation
	var rot_fin := destino.global_rotation
	
	var duracion := 0.4
	var altura_salto := 30.0
	
	animable.play(func(tween):
		ficha.z_index += destino.fichas.size() * 50

		# --- PARTE PARALELA ---
		tween.set_parallel(true)

		# Movimiento
		tween.tween_method(
			func(t):
				var pos_lerp:= pos_inicio.lerp(pos_fin, t)
				var arco:= sin(t*PI)*altura_salto
				ficha.global_position = pos_lerp + dir * arco,
			0.0,
			1.0,
			duracion
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


		# Rotación (AHORA sí paralela)
		tween.tween_method(
			func(t):
				ficha.global_rotation = lerp_angle(rot_inicio, rot_fin, t),
			0.0,
			1.0,
			duracion
		).set_trans(Tween.TRANS_LINEAR)

		# --- ESCALA (SECUENCIAL DENTRO DEL PARALELO) ---
		var tween_escala:Tween = tween.chain()
		tween_escala.tween_property(ficha, "scale", Vector2(1.25, 1.25), duracion * 0.5)
		tween_escala.tween_property(ficha, "scale", Vector2.ONE, duracion * 0.5)
	)

func animar_ficha_salida(
	ficha: FichaEstandar,
	destino: Casilla,
	animable: Animable
) -> void:
	
	
	var dir:= obtener_vector_radial(ficha.global_rotation)
	var offset:= dir * (destino.fichas.size() * 5)

	var pos_fin := destino.global_position + offset
	var rot_inicio := ficha.global_rotation
	var rot_fin := destino.global_rotation

	animable.play(func(tween):

		# 1️⃣ Desaparecer
		tween.tween_property(ficha, "scale", Vector2.ZERO, 0.4)
		tween.parallel().tween_property(
			ficha,
			"global_rotation",
			rot_inicio + TAU,
			0.4
		)

		# 2️⃣ Teleport (callback)
		tween.chain().tween_callback(func():
			ficha.global_position = pos_fin
			ficha.global_rotation = rot_fin - TAU
		)

		# 3️⃣ Aparecer
		tween.chain().tween_property(ficha, "scale", Vector2.ONE, 0.3)
		tween.parallel().tween_property(
			ficha,
			"global_rotation",
			rot_fin,
			0.3
		)

		# 4️⃣ Saltito (arco)
		tween.chain().tween_method(
			func(t):
				var y := sin(t * PI) * 30.0
				ficha.global_position = pos_fin + dir*y,
			0.0,
			1.0,
			0.4
		)
	)

#endregion
