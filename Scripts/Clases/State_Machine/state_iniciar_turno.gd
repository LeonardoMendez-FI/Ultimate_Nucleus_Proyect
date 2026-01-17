extends StateBaseGame

func evaluar_estado() -> void:
	
	pasar_turno()
	
	if juego.jugador_en_turno.fichas_in_game().is_empty() \
	and juego.jugador_en_turno.fichas_in_base().is_empty():
		for ficha in juego.jugador_en_turno.fichas:
			ficha.regresar_a_base()
		evaluar_estado()
	else:
		state_machine._change_to(GameConstants.GAME_STATES.Tirar_Sacar)

func pasar_turno() -> void:
	var siguiente_jugador:Jugador = juego.jugadores[(juego.jugador_en_turno.get_index()+1)%juego.jugadores.size()]
	if !siguiente_jugador.activo:
		pasar_turno()
	juego.jugador_en_turno = siguiente_jugador
	juego.fondo.actualizar_color_fondo(juego.jugador_en_turno.color)
		
