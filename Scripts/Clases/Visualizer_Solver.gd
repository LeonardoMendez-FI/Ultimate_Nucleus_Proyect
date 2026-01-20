extends Node
class_name VisualizerSolver

const center:Vector2 = Vector2.ZERO
var arranging:bool = false

func get_rotation(current_pos:Vector2) -> float:
	var radial_angle:float
	radial_angle = (current_pos - center).angle()
	
	return radial_angle
	
func get_radial_vector(radial_angle: float) -> Vector2:
	return Vector2(cos(radial_angle), sin(radial_angle))

func arrange_visual_token(tile: TileClass) -> void:
	if arranging:
		return
	
	arranging = true
	var radial_angle := tile.global_rotation
	var direction := get_radial_vector(radial_angle)

	for i in range(tile.tokens.size()):
		var token:TokenClass = tile.tokens[i]
		token.global_rotation = tile.global_rotation
		token.z_index = i + 3
		token.global_position = tile.global_position + direction * (i * 5)
	
	arranging = false
			
#region animaciones movimiento

func token_move_animate(token:TokenClass,
target: TileClass, animable:Animable) -> void:
	
	var direction:= get_radial_vector(token.global_rotation)
	var offset:Vector2 = direction * (target.tokens.size() * 5)
	
	var start_pos := token.global_position
	var end_pos := target.global_position + offset
	var start_rot := token.global_rotation
	var end_rot := target.global_rotation
	
	var duration := 0.4
	var arc_height := 30.0
	
	animable.play(func(tween):
		token.z_index += target.tokens.size() * 50

		# --- PARTE PARALELA ---
		tween.set_parallel(true)

		# Movimiento
		tween.tween_method(
			func(t):
				var pos_lerp:= start_pos.lerp(end_pos, t)
				var arc:= sin(t*PI)*arc_height
				token.global_position = pos_lerp + direction * arc,
			0.0,
			1.0,
			duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


		# Rotación (AHORA sí paralela)
		tween.tween_method(
			func(t):
				token.global_rotation = lerp_angle(start_rot, end_rot, t),
			0.0,
			1.0,
			duration
		).set_trans(Tween.TRANS_LINEAR)

		# --- ESCALA (SECUENCIAL DENTRO DEL PARALELO) ---
		var tween_escala:Tween = tween.chain()
		tween_escala.tween_property(token, "scale", Vector2(1.25, 1.25), duration * 0.5)
		tween_escala.tween_property(token, "scale", Vector2.ONE, duration * 0.5)
	)

func token_spawn_animate(
	token: TokenClass,
	target: TileClass,
	animable: Animable
) -> void:
	
	
	var direction:= get_radial_vector(token.global_rotation)
	var offset:Vector2 = direction * (target.tokens.size() * 5)

	var end_pos := target.global_position + offset
	var start_rot := token.global_rotation
	var end_rot := target.global_rotation

	animable.play(func(tween):

		# 1️⃣ Desaparecer
		tween.tween_property(token, "scale", Vector2.ZERO, 0.4)
		tween.parallel().tween_property(
			token,
			"global_rotation",
			start_rot + TAU,
			0.4
		)

		# 2️⃣ Teleport (callback)
		tween.chain().tween_callback(func():
			token.global_position = end_pos
			token.global_rotation = end_rot - TAU
		)

		# 3️⃣ Aparecer
		tween.chain().tween_property(token, "scale", Vector2.ONE, 0.3)
		tween.parallel().tween_property(
			token,
			"global_rotation",
			end_rot,
			0.3
		)

		# 4️⃣ Saltito (arc)
		tween.chain().tween_method(
			func(t):
				var y := sin(t * PI) * 30.0
				token.global_position = end_pos + (direction * y),
			0.0,
			1.0,
			0.4
		)
	)

#endregion
