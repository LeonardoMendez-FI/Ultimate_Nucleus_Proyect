class_name StateBaseGame
extends StateBase

var game: Game_Manager

func start() -> void:
	game = controlled_node as Game_Manager
	call_deferred("evaluar_estado")

func evaluar_estado() -> void:
	pass
