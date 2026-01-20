extends StateBaseGame

func evaluar_estado() -> void:
	if game.ficha_seleccionada:
		game.ficha_seleccionada.selectable = false
	
	game.boton_girar.selectable = false
