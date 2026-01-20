extends Node2D
class_name Nucleus_Solver

@export var button:bool = false:
	set(value):
		button = value
		if value:
			_on_figura_changed()
		
@export var nucleus_shape:= GameConfiguration.nucleus_shape

var nucleus_dict:Dictionary = {} # shape -> Nucleus
var current_nucleus:Nucleus

func _ready() -> void:
	
	for shape in GameConstants.DIC_FIGURAS.keys():
		var rute := GameScenes.nucleus_scene % [
			GameConstants.DIC_FIGURAS[shape].Name
		]

		var scene:PackedScene = load(rute)
		if not scene:
			push_error("No se pudo cargar: " + rute)
			continue

		var nucleus:Nucleus = scene.instantiate()
		nucleus.visible = false
		nucleus.process_mode = Node.PROCESS_MODE_DISABLED

		add_child(nucleus)
		nucleus_dict[shape] = nucleus
		
	GameConfiguration.nucleus_shape_changed.connect(_on_figura_changed)
	_on_figura_changed()

func _on_figura_changed(shape:=nucleus_shape):
	if current_nucleus:
		current_nucleus.visible = false
		current_nucleus.process_mode = Node.PROCESS_MODE_DISABLED

	current_nucleus = nucleus_dict.get(shape)
	if not current_nucleus:
		return

	current_nucleus.visible = true
	current_nucleus.process_mode = Node.PROCESS_MODE_INHERIT
