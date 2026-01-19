extends Node
class_name Node_Game_Configuration

signal active_players_changed(num_active_player)
signal active_bots_changed(num_active_bots)
signal dificult_bots_changed(dificult)
signal figura_nucleo_changed(figura)

var numero_fichas_jugador:int = 5

var numero_jugadores_activos:int = 4:
	set(value):
		if value <= 0 or value > 4:
			return
			
		numero_jugadores_activos = value
		if numero_bots_activos >= numero_jugadores_activos:
			numero_bots_activos = numero_jugadores_activos - 1
		active_players_changed.emit(value)

var numero_bots_activos:int = 0:
	set(value):
		if value < 0 or value > 3:
			return
			
		numero_bots_activos = value
		active_bots_changed.emit(value)

var dificultad_bots:= GameConstants.DIFICULTAD_BOTS.MEDIO:
	set(value):
		dificultad_bots = value
		dificult_bots_changed.emit(value)

var figura_nucleo:= GameConstants.FIGURAS.Triangulo:
	set(value):
		figura_nucleo = value
		figura_nucleo_changed.emit(value)
		
