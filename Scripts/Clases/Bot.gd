extends Jugador
class_name Bot

var bot_activo:bool = false

func _on_check_button_toggled(toggled_on: bool) -> void:
	bot_activo = toggled_on
