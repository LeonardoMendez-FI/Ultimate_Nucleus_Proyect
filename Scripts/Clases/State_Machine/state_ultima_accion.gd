extends StateBaseGame

func evaluar_estado() -> void:
	
	if juego.ficha_seleccionada: juego.ficha_seleccionada.selectable = false
	if juego.dado_seleccionado: juego.dado_seleccionado.selectable = false
	
	if juego.casilla_seleccionada:
		GameResources.movement_solver.seguir_ruta(juego.dado_seleccionado, juego.ficha_seleccionada, 
		juego.casilla_seleccionada)
		await GameResources.movement_solver.ficha_posicionada
	else:
		juego.nucleus.girar(juego.dado_seleccionado.valor)
		await juego.nucleus.animable.animacion_terminada
	
	siguiente_accion()
	
func siguiente_accion() -> void:
	
	for dado:Dado_Estandar in juego.dados:
		if dado.selectable:
			dado.selectable = false
			if GameResources.movement_solver.fichas_can_move(juego.jugador_en_turno, dado.valor).is_empty():
					juego.state_machine._change_to(GameConstants.GAME_STATES.Tirar_Sacar)
			else:
				dado.seleccionar()
			
			return
			
	juego.dado_seleccionado = null
	juego.state_machine._change_to(GameConstants.GAME_STATES.Nuevo_Turno)
			

func end() -> void:
	juego.casilla_seleccionada = null
	juego.ficha_seleccionada = null
