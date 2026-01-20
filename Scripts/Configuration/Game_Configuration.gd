extends Node
class_name NodeGameConfiguration

signal active_players_changed(num_active_player)
signal active_bots_changed(num_active_bots)
signal bots_dificult_changed(dificult)
signal nucleus_shape_changed(figura)

var player_tokens_number:int = 5

var active_players_number:int = 4:
	set(value):
		if value < 2 or value > 4:
			return
			
		active_players_number = value
		
		if active_bots_number >= active_players_number:
			active_bots_number = active_players_number - 1
		active_players_changed.emit(value)

var active_bots_number:int = 0:
	set(value):
		if value < 0 or value > 3:
			return
			
		active_bots_number = value
		active_bots_changed.emit(value)

var bots_dificult:= GameConstants.BOTS_DIFICULT.MEDIUM:
	set(value):
		bots_dificult = value
		bots_dificult_changed.emit(value)

var nucleus_shape:= GameConstants.NUCLEUS_SHAPES.Triangle:
	set(value):
		nucleus_shape = value
		nucleus_shape_changed.emit(value)
		
