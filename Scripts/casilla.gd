extends Selectionable_Area
class_name Casilla

@export var habilidad := GameConstants.HABILIDADES_CASILLA.ESTANDAR:
	set(value):
		habilidad = value
		inicializar_sprites()
		_actualizar_estado_visual()
		
@export var color_habilidad := GameConstants.COLORES_PLAYER.ALL:
	set(value):
		color_habilidad = value
		inicializar_sprites()
		_actualizar_estado_visual()
		
@export var tipo_casilla: = GameConstants.TIPO_CASILLA.TABLERO:
	set(value):
		tipo_casilla = value
		inicializar_sprites()
		_actualizar_estado_visual()
		
@export_dir var dir_sprites

@export var sprite : Sprite2D
@export var icon : AnimatedSprite2D

var index_casilla : int = 0
var fichas:Array[FichaEstandar] = []

var in_rute:bool = false: 
	set(value):
		in_rute = value
		_actualizar_estado_visual()


func _process(_delta: float) -> void:
	if GameResources.casilla_solver.ordenando:
		return
	for ficha in fichas:
		ficha.global_rotation = 0
	GameResources.casilla_solver.reordenar_fichas_visualmente(self)

func _ready() -> void:
	super._ready()
	set_process(false)
	
# FACTORY CASILLA
func configurar(args := {}) -> void:
	index_casilla = args.get("index", 0)
	tipo_casilla = args.get("tipo", GameConstants.TIPO_CASILLA.TABLERO)
	habilidad = args.get("habilidad", GameConstants.HABILIDADES_CASILLA.ESTANDAR)
	color_habilidad = args.get("color", GameConstants.COLORES_PLAYER.ALL)
	global_position = args.get("posicion", Vector2.ZERO)
	selectable = args.get("selectable", false)
	rotate(args.get("angulo", 0))

func inicializar_sprites() -> void:
	var strings_rute := [tipo_casilla,habilidad,color_habilidad, dir_sprites]
	for i in range(strings_rute.size()-1):
		strings_rute[i] = str(strings_rute[i]).capitalize()
	
	var ruta_sprite := "{3}/Sprite/Casilla_{0}_{1}_{2}.png".format(strings_rute)
	print(ruta_sprite)
	sprite.texture = load(ruta_sprite)

func _on_nucleo_girando(girando:bool) -> void:
	if not fichas.is_empty() and girando:
		set_process(true)
		print("Process Activado")
	else:
		set_process(false)

func _actualizar_estado_visual() -> void:
	if selectable:
		icon.play("Activo")
	else:
		if in_rute:
			icon.play("In_Rute")
		else: 
			icon.play("Inactivo")
			#
#func _on_mouse_entered():
	#if selectable:
		#global_scale = Vector2(1.2, 1.2)
#
#func _on_mouse_exited():
	#if selectable and !select:
		#global_scale = Vector2.ONE
	
