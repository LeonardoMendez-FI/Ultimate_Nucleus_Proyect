extends Node2D
class_name Nucleus_Solver

var figura_nucleo:GameConstants.FIGURAS
var rute_escene:String
var escene_nucleus:PackedScene
var nucleus_actual:Nucleus

func _ready() -> void:
	GameConfiguration.figura_nucleo_changed.connect(_on_figura_changed)
	_on_figura_changed()

func _on_figura_changed() -> void:
	
	if nucleus_actual and is_instance_valid(nucleus_actual):
		nucleus_actual.queue_free()
	
	figura_nucleo = GameConfiguration.figura_nucleo
	rute_escene = GameScenes.scene_nucleus%[GameConstants.DIC_FIGURAS[figura_nucleo].Nombre]
	escene_nucleus = load(rute_escene)
	
	if not escene_nucleus:
		push_error("No se pudo cargar la escena: " + rute_escene)
		return
		
	nucleus_actual = escene_nucleus.instantiate()
	
	add_child(nucleus_actual)
