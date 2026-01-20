extends StateBaseGame

func start():
	super.start()
	call_deferred("_activar_opciones")

func _activar_opciones():
	if not game.players_solver.current_player.fichas_in_game().is_empty():
		game.boton_tirar.selectable = true
	
	for ficha in game.players_solver.current_player.fichas_in_base():
		ficha.selectable = true

func end() -> void:
	for ficha in game.players_solver.current_player.fichas_in_base():
		ficha.selectable = false
	game.boton_tirar.selectable = false
