extends StateBaseGame

func evaluar_estado() -> void:
	game.ficha_seleccionada.sacar_de_base()
	await game.ficha_seleccionada.animable.animacion_terminada
	
	game.dado_seleccionado = game.dados[0]
	game.dado_seleccionado.lanzar()
	
	await game.dado_seleccionado.animable.animacion_terminada
	game.dado_seleccionado.selectable = false
	game.dado_seleccionado.select = true
	
	while(game.ficha_seleccionada.rutas.is_empty()):
		game.dado_seleccionado._cambiar_valor_aleatorio()
		game.ficha_seleccionada.rutas = GameResources.movement_solver.obtener_trayectorias(
			game.ficha_seleccionada, game.dado_seleccionado.valor)
	
	game.ficha_seleccionada.seleccionar()
