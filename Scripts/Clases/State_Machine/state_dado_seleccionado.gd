extends StateBaseGame

func evaluar_estado() -> void:
	
	if juego.ficha_seleccionada: juego.ficha_seleccionada.selectable = false
	juego.boton_girar.selectable = true
	
	for ficha in GameResources.movement_solver.fichas_can_move(juego.jugador_en_turno, 
	juego.dado_seleccionado.valor):
		ficha.selectable = true

func end() -> void:
	for ficha in juego.jugador_en_turno.fichas:
		if ficha != juego.ficha_seleccionada:
			ficha.selectable = false
			ficha.rutas.clear()
	
	juego.boton_girar.selectable = false
