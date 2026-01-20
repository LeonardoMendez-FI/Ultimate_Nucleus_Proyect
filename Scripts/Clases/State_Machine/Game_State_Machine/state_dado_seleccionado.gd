extends StateBaseGame

func evaluar_estado() -> void:
	
	if game.ficha_seleccionada: game.ficha_seleccionada.selectable = false
	game.boton_girar.selectable = true
	
	for ficha in GameResources.movement_solver.fichas_can_move\
	(game.players_solver.current_player, game.dado_seleccionado.valor):
		ficha.selectable = true

func end() -> void:
	for ficha in game.players_solver.current_player.fichas:
		if ficha != game.ficha_seleccionada:
			ficha.selectable = false
			ficha.rutas.clear()
	
	game.boton_girar.selectable = false
