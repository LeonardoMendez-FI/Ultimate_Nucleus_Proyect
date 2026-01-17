extends Node
class_name MovementSolver

signal ficha_posicionada
var tablero:Tablero = null
var nucleus:Nucleus = null

func fichas_can_move(
	jugador:Jugador,
	valor_dado:int,
) -> Array[FichaEstandar]:

	var fichas_move:Array[FichaEstandar] = []

	for ficha in jugador.fichas_in_game():
		ficha.rutas.clear()
		ficha.rutas = obtener_trayectorias(
			ficha, valor_dado
		)

		if not ficha.rutas.is_empty():
			fichas_move.append(ficha)

	return fichas_move

func obtener_trayectorias(
	ficha:FichaEstandar,
	valor_dado:int,
) -> Dictionary:

	var rutas:Dictionary = {}
	
	# Usar un diccionario para pasar por "referencia"
	var estado_busqueda:Dictionary = {
		"encontro_salida": false,
		"ruta_salida": []
	}
	
	# Verificar si la ficha comienza en una conexión
	var es_conexion_inicial:bool = (
		ficha.casilla_actual in nucleus.entrada_salida or
		ficha.casilla_actual in nucleus.entrada_salida.values()
	)
	
	var conexion_bloqueada = ficha.ultima_conexion_usada
	var _partida_especial = false
	
	# Si comienza en una conexión y NO es la que usó en el turno anterior
	if es_conexion_inicial and ficha.casilla_actual != conexion_bloqueada:
		# Puede cambiar de tablero inmediatamente
		# Buscamos la conexión opuesta
		var otra_punta:Casilla = null
		
		if ficha.casilla_actual in nucleus.entrada_salida:
			# Es una entrada del núcleo → la salida está en el tablero
			otra_punta = nucleus.entrada_salida[ficha.casilla_actual]
		else:
			# Es una salida del núcleo → la entrada está en el núcleo
			for entrada in nucleus.entrada_salida:
				if nucleus.entrada_salida[entrada] == ficha.casilla_actual:
					otra_punta = entrada
					break
		
		if otra_punta != null:
			# Comenzamos desde la otra punta de la conexión
			_partida_especial = true
			var ruta_inicial:Array[Casilla] = [otra_punta]
			
			# Verificar si la otra punta es la casilla de salida
			if otra_punta == ficha.propietario.casilla_salida:
				estado_busqueda["encontro_salida"] = true
				estado_busqueda["ruta_salida"] = ruta_inicial
			else:
				# Reiniciar estado para esta búsqueda
				var estado_temp:Dictionary = {
					"encontro_salida": false,
					"ruta_salida": []
				}
				
				buscar_ruta(
					ficha,
					ruta_inicial,
					valor_dado - 1,  # Ya usamos 1 paso para cambiar de tablero
					otra_punta,
					rutas,
					ficha.casilla_actual,  # Esta conexión queda bloqueada ahora
					estado_temp
				)
				
				if estado_temp["encontro_salida"]:
					estado_busqueda["encontro_salida"] = true
					estado_busqueda["ruta_salida"] = estado_temp["ruta_salida"]
	
	# También buscar rutas normales (sin cambio inmediato)
	# IMPORTANTE: Siempre buscar rutas normales, incluso si está en conexión
	# Esto arregla el problema de que con valor_dado = 1 no muestra la opción de seguir en el mismo tablero
	if not estado_busqueda["encontro_salida"]:  # Solo buscar si no encontramos salida ya
		# Ruta vacía inicial para movimiento normal
		var ruta_inicial:Array[Casilla] = []
		
		# Reiniciar estado para esta búsqueda
		var estado_temp:Dictionary = {
			"encontro_salida": false,
			"ruta_salida": []
		}
		
		buscar_ruta(
			ficha,
			ruta_inicial,
			valor_dado,
			ficha.casilla_actual,
			rutas,
			conexion_bloqueada,
			estado_temp
		)
		
		if estado_temp["encontro_salida"]:
			estado_busqueda["encontro_salida"] = true
			estado_busqueda["ruta_salida"] = estado_temp["ruta_salida"]
	
	# Si encontramos la salida, limpiar todas las otras rutas
	if estado_busqueda["encontro_salida"]:
		rutas.clear()
		rutas[ficha.propietario.casilla_salida] = estado_busqueda["ruta_salida"]
	
	return rutas

func buscar_ruta(
	ficha:FichaEstandar,
	ruta_actual:Array[Casilla],
	pasos_restantes:int,
	casilla_actual:Casilla,
	rutas:Dictionary,
	conexion_bloqueada:Casilla = null,
	estado_busqueda:Dictionary = {}
) -> void:

	# Si ya encontramos la salida en otra rama, no continuar
	if estado_busqueda.get("encontro_salida", false):
		return

	# Solo agregamos al diccionario cuando terminamos los pasos
	if pasos_restantes == 0:
		# IMPORTANTE: Verificamos si la casilla actual ES la salida
		if casilla_actual == ficha.propietario.casilla_salida:
			# ¡Encontramos la salida en el último paso!
			var ruta_final = ruta_actual.duplicate()
			estado_busqueda["encontro_salida"] = true
			estado_busqueda["ruta_salida"] = ruta_final
		elif _casilla_disponible(ficha, casilla_actual):
			var ruta_final = ruta_actual.duplicate()

			if not rutas.has(casilla_actual):
				# Primera ruta a esta casilla
				rutas[casilla_actual] = ruta_final
			else:
				# Comparar directez
				var ruta_existente = rutas[casilla_actual]

				var cambios_existente = _contar_cambios_tablero(ruta_existente)
				var cambios_nueva = _contar_cambios_tablero(ruta_final)

				if cambios_nueva < cambios_existente:
					rutas[casilla_actual] = ruta_final

		return

	var camino:Array[Casilla]
	var es_tablero:bool

	if casilla_actual.tipo_casilla == GameConstants.TIPO_CASILLA.TABLERO:
		camino = tablero.casillas_internas
		es_tablero = true
	else:
		camino = nucleus.casillas
		es_tablero = false

	# ───── 1️⃣ AVANZAR SIEMPRE ─────
	var idx := casilla_actual.index_casilla
	var siguiente := camino[(idx + 1) % camino.size()]

	# Creamos nueva ruta agregando la siguiente casilla
	var nueva_ruta := ruta_actual.duplicate()
	nueva_ruta.append(siguiente)

	# Verificar si la siguiente casilla es la salida ANTES de continuar
	if siguiente == ficha.propietario.casilla_salida:
		# ¡Encontramos la salida! Guardar esta ruta
		var ruta_final = nueva_ruta.duplicate()
		estado_busqueda["encontro_salida"] = true
		estado_busqueda["ruta_salida"] = ruta_final
		return  # Cortar la búsqueda - encontramos la meta

	# Continuar por el mismo camino solo si no es la salida
	buscar_ruta(
		ficha,
		nueva_ruta,
		pasos_restantes - 1,
		siguiente,
		rutas,
		conexion_bloqueada,
		estado_busqueda
	)

	# Si ya encontramos la salida, no explorar más
	if estado_busqueda.get("encontro_salida", false):
		return

	# ───── 2️⃣ VERIFICAR CAMBIO DE TABLERO (2 pasos) ─────
	# Solo podemos cambiar de tablero si tenemos al menos 2 pasos restantes
	if pasos_restantes >= 2:
		var conexion_entrada:Casilla = null
		var conexion_salida:Casilla = null
		
		if es_tablero:
			# Tablero → Núcleo
			for entrada in nucleus.entrada_salida.keys():
				var salida = nucleus.entrada_salida[entrada]
				if salida == siguiente:
					# Verificar si esta conexión está bloqueada
					# NO puede ser la misma que ya usó
					if entrada != conexion_bloqueada:
						conexion_entrada = siguiente
						conexion_salida = entrada
					break
		else:
			# Núcleo → Tablero
			if siguiente in nucleus.entrada_salida.keys():
				var salida = nucleus.entrada_salida[siguiente]
				# Verificar si esta conexión está bloqueada
				# NO puede ser la misma que ya usó
				if salida != conexion_bloqueada:
					conexion_entrada = siguiente
					conexion_salida = salida

		# Si encontramos una conexión válida, explorar ese camino (2 pasos)
		if conexion_entrada != null and conexion_salida != null:
			# Creamos una ruta que incluya ambos pasos
			var ruta_conexion := ruta_actual.duplicate()
			ruta_conexion.append(conexion_entrada)
			
			var ruta_con_salida := ruta_conexion.duplicate()
			ruta_con_salida.append(conexion_salida)
			
			# Verificar si la conexión de salida es la casilla de salida
			if conexion_salida == ficha.propietario.casilla_salida:
				var ruta_final = ruta_con_salida.duplicate()
				estado_busqueda["encontro_salida"] = true
				estado_busqueda["ruta_salida"] = ruta_final
				return
			
			# IMPORTANTE: La nueva conexión bloqueada es la que estamos usando
			# para entrar al otro tablero (conexion_salida si vamos al núcleo,
			# conexion_entrada si vamos al tablero)
			var nueva_conexion_bloqueada:Casilla
			if es_tablero:
				nueva_conexion_bloqueada = conexion_salida  # Entrada al núcleo
			else:
				nueva_conexion_bloqueada = conexion_entrada  # Entrada del núcleo
			
			# Llamamos recursivamente con pasos_restantes - 2
			buscar_ruta(
				ficha,
				ruta_con_salida,
				pasos_restantes - 2,
				conexion_salida,
				rutas,
				nueva_conexion_bloqueada,
				estado_busqueda
			)

func _casilla_disponible(
	ficha_buscando:FichaEstandar,
	casilla:Casilla
) -> bool:

	# La casilla de salida SIEMPRE está disponible
	if casilla == ficha_buscando.propietario.casilla_salida:
		return true

	if not casilla.fichas.is_empty():
		var ultima_ficha = casilla.fichas[-1]
		if (
				(casilla.habilidad == GameConstants.HABILIDADES_CASILLA.PROTECCION \
				and (casilla.color_habilidad == GameConstants.COLORES_PLAYER.ALL or\
				casilla.color_habilidad == ultima_ficha.propietario.color)) or\
				
				(ficha_buscando.propietario == ultima_ficha.propietario)
		):
			return false

	return true

func _contar_cambios_tablero(ruta:Array[Casilla]) -> int:
	if ruta.is_empty():
		return 0

	var cambios := 0
	var tipo_anterior = ruta[0].tipo_casilla

	for casilla in ruta:
		if casilla.tipo_casilla != tipo_anterior:
			cambios += 1
			tipo_anterior = casilla.tipo_casilla

	return cambios

	
func seguir_ruta(
	dado:Dado_Estandar,
	ficha_selected:FichaEstandar,
	casilla_selected:Casilla
) -> void:

	# Obtener la ruta seleccionada
	var ruta_seleccionada = ficha_selected.rutas.get(casilla_selected, [])
	if ruta_seleccionada.is_empty():
		print("Error: Ruta vacía o no encontrada para la casilla seleccionada")
		return
	
	
	# Variables para rastrear el estado durante el movimiento
	var fichas_ancladas:Array[FichaEstandar] = ficha_selected.casilla_actual.fichas.duplicate()
	var ultima_casilla:Casilla = ficha_selected.casilla_actual
	var conexion_usada: Casilla = null
	var ya_cambio_tablero: bool = false

	# Si la casilla seleccionada es la casilla de salida, 
	# tenemos un comportamiento especial
	var es_casilla_salida: bool = (casilla_selected == ficha_selected.propietario.casilla_salida)

	# Animar el recorrido paso a paso
	for casilla:Casilla in ruta_seleccionada:
		
		# Verificar si estamos cambiando de tablero
		# (comparamos con la última casilla antes de mover)
		if ultima_casilla.tipo_casilla != casilla.tipo_casilla:
			# Esta es una conexión entre tableros
			conexion_usada = casilla
			ya_cambio_tablero = true
			
			# Determinar a qué tablero pertenece esta casilla
			if casilla.tipo_casilla == GameConstants.TIPO_CASILLA.NUCLEUS:
				for ficha in fichas_ancladas:
					ficha.reparent(nucleus)
				print("Ficha cambiada al núcleo en conexión: ", casilla.index_casilla)
			else:
				for ficha in fichas_ancladas:
					ficha.reparent(tablero)
				print("Ficha cambiada al tablero en conexión: ", casilla.index_casilla)
		
		# Mover a la casilla (animación)
		print("Moviendo ficha a casilla: ", casilla.index_casilla)

		for i in range(fichas_ancladas.size()-1, -1, -1):
			fichas_ancladas[i].set_z_index(25 + 51*(i+1))
			print(fichas_ancladas[i].get_z_index())
		
		for ficha in fichas_ancladas:
			ficha.mover_a_casilla(casilla)
			await Engine.get_main_loop().create_timer(0.1).timeout
		
		await fichas_ancladas[-1].animable.animacion_terminada
		
		# Verificar si llegamos a la casilla de salida
		if es_casilla_salida and casilla == ficha_selected.propietario.casilla_salida:
			print("¡Ficha llegó a su casilla de salida!")
			# Podríamos agregar efectos especiales aquí si es necesario
			break
		
		# Actualizar la última casilla para la siguiente iteración
		ultima_casilla = casilla

	# Actualizar la última conexión usada SOLO si realmente cambiamos de tablero
	if ya_cambio_tablero:
		ficha_selected.ultima_conexion_usada = conexion_usada
		print("Conexión bloqueada para siguiente turno: ", 
			  str(conexion_usada.index_casilla) if conexion_usada else "ninguna")
	else:
		ficha_selected.ultima_conexion_usada = null
	
	GameResources.casilla_solver.caer_in_casilla(dado, ficha_selected, 
	casilla_selected)
	
	# Emitir señal de que la ficha fue posicionada
	ficha_posicionada.emit()

	# Limpiar rutas después de usarlas
	ficha_selected.rutas.clear()
