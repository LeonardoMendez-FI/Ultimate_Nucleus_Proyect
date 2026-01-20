# Nucleus_Bakery.gd - SÓLO para create
extends Node
class_name NucleusBakery

var building := false
var new_nucleus:NucleusClass
const tile_scene = preload(GameScenes.tile_scene)

@export var guardar:bool = false:
	set(value):
		if value:
			save_as_escene()
		guardar = false

@export var nucleus_shape: = GameConstants.NUCLEUS_SHAPES.Triangle:
	set(value):
		nucleus_shape = value
		entrances_number = GameConstants.DIC_FIGURAS[nucleus_shape].Entrances_Number
		side_tiles_number = GameConstants.DIC_FIGURAS[nucleus_shape].Side_Tiles_Number
		
		if new_nucleus and is_instance_valid(new_nucleus):
			new_nucleus.queue_free()
		
		create()
		
var entrances_number : int
var side_tiles_number : int 

func _ready():
	# Este script SÓLO genera y guarda
	create()


func create():
	if building:
		return
	building = true
	# Crear tablero correctamente
	new_nucleus = NucleusClass.new()
	add_child(new_nucleus)
	new_nucleus.owner = self

	new_nucleus.entrances_number = entrances_number
	
	var anim = Animable.new()
	new_nucleus.animable = anim
	new_nucleus.add_child(anim)
	anim.owner = new_nucleus
	anim.name = "Animable"
	

	call_deferred("_nucleus_builder")	
	call_deferred("_finished_creation")

func _finished_creation():
	building = false

func _nucleus_builder() -> void:

	var vertexs: Array[Vector2] = []

	for i in range(entrances_number):
		var radial_angle := deg_to_rad(-i * (360.0 / entrances_number) + 5)
		vertexs.append(
			new_nucleus.global_position +
			Vector2(
				GameConstants.NUCLEUS_RADIUS * cos(radial_angle),
				GameConstants.NUCLEUS_RADIUS * sin(radial_angle)
			)
		)

	var tile_idx := 0

	for i in range(entrances_number):
		var start: Vector2 = vertexs[i]
		var end: Vector2 = vertexs[(i + 1) % entrances_number]
		var side_direction := (end - start).normalized()
		var normal := Vector2(-side_direction.y, side_direction.x)
		var side_angle := GameResources.visualizer_solver.get_rotation(normal)

		for j in range(side_tiles_number - 1):
			var t := float(j) / float(side_tiles_number - 1)
			var pos := start.lerp(end, t)
			var new_tile: TileClass 
			var radial_angle
			if j>0: radial_angle = side_angle 
			else: radial_angle = GameResources.visualizer_solver.get_rotation(pos)
			
			new_tile = _create_tile({"current_position":pos, "index":tile_idx, 
			"type":GameConstants.TILE_TYPES.NUCLEUS, "radial_angle":radial_angle})

			# Vértice / Entrada-Salida
			if j == 0:
				new_tile.add_to_group("Nucleus Vertex", true)

			tile_idx += 1
			
func _create_tile(args:={}) -> TileClass:

	var new_tile:TileClass = tile_scene.instantiate()
	new_tile.configurate(args)
	new_nucleus.add_child(new_tile)
	new_tile.owner = new_nucleus
	new_tile.name = "Nucleus_Tile_%02d" % [args["index"]]
	new_tile.add_to_group("Nucleus Tile", true)
	
	return new_tile
	
func save_as_escene():
	var escene = PackedScene.new()
	escene.pack(new_nucleus)
	ResourceSaver.save(escene, GameScenes.scene_nucleus%[GameConstants.SHAPES_DICT[nucleus_shape].Name])
	print("✅ Guardado!")
