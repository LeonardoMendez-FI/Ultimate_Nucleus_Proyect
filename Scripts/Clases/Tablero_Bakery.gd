# Tablero_Baker.gd - SÓLO para generar
extends Node
class_name TableroBaker

var escena_casilla:= preload(GameScenes.scene_casilla)
var nuevo_tablero:Tablero

@export var guardar:bool = false:
	set(value):
		if value:
			guardar_como_escena()

func _ready():
	# Este script SÓLO genera y guarda
	generar()


func generar():
	# Crear tablero correctamente
	nuevo_tablero = Tablero.new()
	add_child(nuevo_tablero)

	# CLAVE: owner para que se pueda guardar
	nuevo_tablero.owner = self

	call_deferred("_crear_tablero")

func _crear_tablero() -> void:
	for indice in range(36):
		var angulo:float = deg_to_rad(indice * 10 - 5)
			
		var pos_int = Game_Constants.RADIO_INT*GameResources.visualizer_solver.obtener_vector_radial(-angulo)
		var pos_ext = Game_Constants.RADIO_EXT*GameResources.visualizer_solver.obtener_vector_radial(-angulo)
		nuevo_tablero.casillas_internas.append(_crear_casilla({"posicion":pos_int, "index":indice, 
		"tipo":GameConstants.TIPO_CASILLA.TABLERO, "angulo":-angulo}, true))
		
		nuevo_tablero.casillas_externas.append(_crear_casilla({"posicion":pos_ext, "index":36-indice, 
		"tipo":GameConstants.TIPO_CASILLA.BASE, "angulo":-angulo}, false))
		
func _crear_casilla(args:={}, vision:bool = true) -> Casilla:
	var nueva_casilla:Casilla = escena_casilla.instantiate()
	nueva_casilla.visible = vision
	nueva_casilla.configurar(args)
	nuevo_tablero.add_child(nueva_casilla)
	nueva_casilla.owner = nuevo_tablero
	nueva_casilla.name = "Casilla_%s_%02d" % [GameConstants.STR_TIPOS[args["tipo"]], args["index"]]
	nueva_casilla.add_to_group("Casilla %s"%[GameConstants.STR_TIPOS[args["tipo"]]], true)
	
	return nueva_casilla
	
func guardar_como_escena():
	var escena = PackedScene.new()
	escena.pack(nuevo_tablero)
	ResourceSaver.save(escena, "res://Scenes/TheGame/Componentes/Tablero.tscn")
	print("✅ Guardado!")
