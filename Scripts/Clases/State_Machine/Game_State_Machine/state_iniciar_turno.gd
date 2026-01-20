extends StateBaseGame

func evaluar_estado() -> void:
	
	if game.players_solver.current_player.fichas_in_game().is_empty() \
	and game.players_solver.current_player.fichas_in_base().is_empty():
		for ficha in game.players_solver.current_player.fichas:
			ficha.regresar_a_base()
		evaluar_estado()
	else:
		state_machine._change_to(GameConstants.GAME_STATES.Tirar_Sacar)
		
