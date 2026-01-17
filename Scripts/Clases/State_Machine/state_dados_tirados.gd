extends StateBaseGame

func evaluar_estado() -> void:
	if juego.ficha_seleccionada:
		juego.ficha_seleccionada.selectable = false
	
	juego.boton_girar.selectable = false
