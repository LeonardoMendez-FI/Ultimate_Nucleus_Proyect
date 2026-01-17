extends StateBaseGame

func start():
	super.start()
	call_deferred("_activar_opciones")

func _activar_opciones():
	if not juego.jugador_en_turno.fichas_in_game().is_empty():
		juego.boton_tirar.selectable = true
	
	for ficha in juego.jugador_en_turno.fichas_in_base():
		ficha.selectable = true

func end() -> void:
	for ficha in juego.jugador_en_turno.fichas_in_base():
		ficha.selectable = false
	juego.boton_tirar.selectable = false
