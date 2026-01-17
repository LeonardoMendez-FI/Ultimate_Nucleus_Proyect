extends StateBaseGame

func evaluar_estado() -> void:
	juego.ficha_seleccionada.sacar_de_base()
	await juego.ficha_seleccionada.animable.animacion_terminada
	
	juego.dado_seleccionado = juego.dados[0]
	juego.dado_seleccionado.lanzar()
	
	await juego.dado_seleccionado.animable.animacion_terminada
	juego.dado_seleccionado.selectable = false
	juego.dado_seleccionado.select = true
	
	while(juego.ficha_seleccionada.rutas.is_empty()):
		juego.dado_seleccionado._cambiar_valor_aleatorio()
		juego.ficha_seleccionada.rutas = GameResources.movement_solver.obtener_trayectorias(
			juego.ficha_seleccionada, juego.dado_seleccionado.valor)
	
	juego.ficha_seleccionada.seleccionar()
