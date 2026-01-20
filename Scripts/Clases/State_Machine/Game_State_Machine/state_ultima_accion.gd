extends StateBaseGame

func evaluar_estado() -> void:
	
	if game.ficha_seleccionada: game.ficha_seleccionada.selectable = false
	if game.dado_seleccionado: game.dado_seleccionado.selectable = false
	
	if game.casilla_seleccionada:
		GameResources.movement_solver.seguir_ruta(game.dado_seleccionado, game.ficha_seleccionada, 
		game.casilla_seleccionada)
		await GameResources.movement_solver.ficha_posicionada
	else:
		game.nucelus_solver.current_nucleus.girar(game.dado_seleccionado.valor)
		await game.nucelus_solver.current_nucleus.animable.animacion_terminada
	
	siguiente_accion()
	
func siguiente_accion() -> void:
	
	for dado:Dado_Estandar in game.dados:
		if dado.selectable:
			dado.selectable = false
			if GameResources.movement_solver.fichas_can_move\
			(game.players_solver.current_player, dado.valor).is_empty():
					game.state_machine._change_to(GameConstants.GAME_STATES.Tirar_Sacar)
			else:
				dado.seleccionar()
			
			return
			
	game.dado_seleccionado = null
	game.players_solver.pasar_turno()
			

func end() -> void:
	game.casilla_seleccionada = null
	game.ficha_seleccionada = null
