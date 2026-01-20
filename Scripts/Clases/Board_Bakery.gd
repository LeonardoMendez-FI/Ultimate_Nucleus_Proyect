# Board_Baker.gd - SÓLO para generar
extends Node
class_name BoardBakery

var tile_scene:= preload(GameScenes.tile_scene)
var new_board:BoardClass

@export var save:bool = false:
	set(value):
		if value:
			save_as_scene()

func _ready():
	# Este script SÓLO genera y guarda
	create()


func create():
	# Crear tablero correctamente
	new_board = BoardClass.new()
	add_child(new_board)

	# CLAVE: owner para que se pueda save
	new_board.owner = self

	call_deferred("_board_builder")

func _board_builder() -> void:
	for index in range(36):
		var radial_angle:float = deg_to_rad(index * 10 - 5)
			
		var int_pos = GameConstants.INT_RADIUS*\
		GameResources.visualizer_solver.get_radial_vector(-radial_angle)
		
		var out_pos = GameConstants.EXT_RADIUS*\
		GameResources.visualizer_solver.get_radial_vector(-radial_angle)
		
		new_board.int_tiles.append(_create_tile({"position":int_pos, "index":index, 
		"type":GameConstants.TILE_TYPES.BOARD, "radial_angle":-radial_angle}, true))
		
		new_board.out_tiles.append(_create_tile({"current_position":out_pos, "index":36-index, 
		"type":GameConstants.TILE_TYPES.BASE, "radial_angle":-radial_angle}, false))
		
func _create_tile(args:={}, vision:bool = true) -> TileClass:
	var new_tile:TileClass = tile_scene.instantiate()
	new_tile.visible = vision
	new_tile.configurate(args)
	new_board.add_child(new_tile)
	new_tile.owner = new_board
	new_tile.name = "%s_Tile_%02d" % [GameConstants.STR_TILE_TYPES[args["type"]], args["index"]]
	new_tile.add_to_group("%s Tile"%[GameConstants.STR_TILE_TYPES[args["type"]]], true)
	
	return new_tile
	
func save_as_scene():
	var scene = PackedScene.new()
	scene.pack(new_board)
	ResourceSaver.save(scene, GameScenes.board_scene)
	print("✅ Guardado!")
