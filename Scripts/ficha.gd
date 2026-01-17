extends Selectionable_Area
class_name FichaEstandar

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@export_dir var dir_sprites
@onready var animable:Animable = $Animable

var propietario : Jugador = null
var capturada:bool = false
var rutas:Dictionary = {} # Dictionary[Casilla, Array[Casilla]]
var casilla_base = null
var casilla_actual:Casilla = null
var ultima_conexion_usada: Casilla = null

#region configuracion
func configurar(jugador:Jugador, base:Casilla) -> void:
	propietario = jugador
	sprite.sprite_frames = sprite.sprite_frames.duplicate()
	_inicializar_sprites()
	casilla_base = base
	regresar_a_base()

func _ready() -> void:
	super._ready()
	
func _inicializar_sprites():
	
	var dic_rutas : Dictionary = {"Estandar":"/FichaEstandar_", 
	"Seleccionable":"/FichaSeleccionable_","Seleccionada":"/FichaEstandar_"}
	
	var frames := sprite.sprite_frames
	
	for anim_name in frames.get_animation_names():
		if not dic_rutas.has(anim_name):
			continue
			
		frames.clear(anim_name) # borra SOLO los frames
		frames.add_frame(anim_name, load(dir_sprites + dic_rutas[anim_name]\
		 + propietario.color + ".png"))	
	
func _actualizar_estado_visual() -> void:
	
	if select:
		mostrar_rutas(true)
		sprite.play("Seleccionada")
	else:
		mostrar_rutas(false)
		if selectable:
			sprite.play("Seleccionable")
		else:
			sprite.play("Estandar")

#endregion

#region estado actual
func is_in_base() -> bool:
	if casilla_actual.tipo_casilla == GameConstants.TIPO_CASILLA.BASE:
		return true
	else:
		return false

func is_in_game() -> bool:
	if !is_in_base() and !capturada:
		return true
	else:
		return false

#endregion

#region movimiento ficha
func regresar_a_base() -> void:
	mover_a_casilla(casilla_base)
	capturada = false
	rutas.clear()
	ultima_conexion_usada = null

func sacar_de_base() -> void:
	mover_a_casilla(propietario.casilla_salida)
	await animable.animacion_terminada
	GameResources.casilla_solver.capturar_casilla(self)
	
func mover_a_casilla(casilla_destino: Casilla) -> void:
		
	if casilla_actual:
		if casilla_actual and casilla_base and is_in_base():
			_animar_salida_de_base(casilla_destino)
			await animable.animacion_terminada
		else:
			_animar_movimiento_normal(casilla_destino)
			
		GameResources.casilla_solver.eliminar_ficha(self, casilla_actual)
	else:
		_animar_movimiento_normal(casilla_destino)

	GameResources.casilla_solver.agregar_ficha(self, casilla_destino)

#region animaciones movimiento

func _animar_movimiento_normal(destino: Casilla) -> void:
	var inicio := global_position
	var fin := destino.global_position - Vector2(0, (destino.fichas.size())*5)
	var duracion := 0.4 #0.4
	var altura_salto := 30.0
	
	animable.play(func(tween):
		z_index += destino.fichas.size()*50
		print(z_index,z_index)
		tween.set_parallel(true)

		# Movimiento base
		tween.tween_property(
			self,
			"global_position",
			fin,
			duracion
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		# Arco
		tween.tween_method(
			func(t):
				var y_offset := -sin(t * PI) * altura_salto
				global_position.y = lerp(inicio.y, fin.y, t) + y_offset,
			0.0,
			1.0,
			duracion
		)

		# Escala
		tween.tween_property(self, "scale", Vector2(1.25, 1.25), duracion * 0.5)
		tween.chain().tween_property(self, "scale", Vector2.ONE, duracion * 0.5)
	)

		# 👇 Restaurar z cuando termine
	animable.animacion_terminada.connect(
		func():
			animable.animacion_terminada.emit(),
		CONNECT_ONE_SHOT
	)

func _animar_salida_de_base(destino: Casilla) -> void:
	var desaparecer := 0.5 #0.6
	var aparecer := 0.5 #0.6
	
	var tween = create_tween()
	# Desaparecer
	tween.tween_property(self, "rotation", rotation + TAU, desaparecer)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, desaparecer)

	# Teleport
	tween.chain().tween_callback(func():
		global_position = destino.global_position - Vector2(0, (destino.fichas.size())*5))

	# Aparecer
	tween.chain().tween_property(self, "rotation", rotation + TAU * 2, aparecer)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, aparecer)
	
	# 4️⃣ SOLO aquí arrancamos el movimiento normal
	tween.chain().tween_callback(func():
		_animar_movimiento_normal(destino)
	)

#endregion

#endregion

#region rutas

func mostrar_rutas(mostrar:bool = true) -> void:
	
	if rutas.is_empty():
		return
	
	for destino:Casilla in rutas:
		for casilla in rutas[destino]:
			casilla.in_rute = mostrar
		destino.selectable = mostrar
		if ultima_conexion_usada:
			ultima_conexion_usada.icon.modulate = GameConstants.RED

func _on_mouse_entered():
	super._on_mouse_entered()
	mostrar_rutas(selectable)

func _on_mouse_exited():
	super._on_mouse_exited()
	mostrar_rutas(selectable and select)
		
#endregion
