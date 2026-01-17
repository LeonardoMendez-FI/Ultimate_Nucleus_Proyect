class_name StateBaseGame
extends StateBase

var juego: Game_Manager

func start() -> void:
	juego = controlled_node as Game_Manager
	call_deferred("evaluar_estado")

func evaluar_estado() -> void:
	pass
