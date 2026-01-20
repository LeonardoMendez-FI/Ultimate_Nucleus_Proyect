extends StateBaseGame

func evaluar_estado() -> void:
	game._init_game()
	await game.nucleus_solver.current_nucleus.animable.animacion_terminada
	
	game.players_solver._iniciar_turno()
	
	
