extends StateBaseGame

func evaluar_estado() -> void:
	juego._inicializar_juego()
	await juego.nucleus.animable.animacion_terminada
	
	juego.jugador_en_turno = juego.jugadores[GameResources.azar.randi_range(0,3)]
	state_machine._change_to(GameConstants.GAME_STATES.Nuevo_Turno)
	
	
