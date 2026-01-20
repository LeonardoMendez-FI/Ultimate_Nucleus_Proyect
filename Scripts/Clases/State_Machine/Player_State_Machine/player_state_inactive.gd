extends StateBasePlayer

func evaluar_estado() -> void:
	player.visible = false
	player.set_process_input(false)
	player.process_mode = PROCESS_MODE_DISABLED

func end() -> void:
	player.visible = true
	player.set_process_input(true)
	player.process_mode = PROCESS_MODE_ALWAYS
	
