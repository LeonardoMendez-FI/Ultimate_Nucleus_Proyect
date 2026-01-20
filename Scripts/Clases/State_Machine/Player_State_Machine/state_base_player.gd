class_name StateBasePlayer
extends StateBase

var player: Jugador

func start() -> void:
	player = controlled_node as Jugador
	call_deferred("evaluar_estado")

func evaluar_estado() -> void:
	pass
