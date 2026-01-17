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
		 + GameConstants.STR_COLORES[propietario.color] + ".png"))	
	
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
	GameResources.casilla_solver.capturar_casilla(self)
	
func mover_a_casilla(casilla_destino: Casilla) -> void:
		
	if casilla_actual:
		if casilla_actual and casilla_base and is_in_base():
			GameResources.visualizer_solver.animar_ficha_salida(self, casilla_destino, animable)
		else:
			GameResources.visualizer_solver.animar_ficha_move(self, casilla_destino, animable)
			
		GameResources.casilla_solver.eliminar_ficha(self, casilla_actual)
	else:
		GameResources.visualizer_solver.animar_ficha_move(self, casilla_destino, animable)

	GameResources.casilla_solver.agregar_ficha(self, casilla_destino)

#endregion

#region rutas

func mostrar_rutas(mostrar:bool = true) -> void:
	
	if rutas.is_empty():
		return
	
	for destino:Casilla in rutas:
		for casilla in rutas[destino]:
			casilla.in_rute = mostrar
		destino.selectable = mostrar

func _on_mouse_entered():
	super._on_mouse_entered()
	mostrar_rutas(selectable)

func _on_mouse_exited():
	super._on_mouse_exited()
	mostrar_rutas(selectable and select)
		
#endregion
