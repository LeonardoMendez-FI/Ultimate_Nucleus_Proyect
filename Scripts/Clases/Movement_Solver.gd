extends Node
class_name MovementSolver

signal placed_token
var current_board:BoardClass = null
var current_nucleus:NucleusClass = null

func tokens_can_move(
	player:PlayerClass,
	dice_value:int,
) -> Array[TokenClass]:

	var active_tokens:Array[TokenClass] = []

	for token in player.tokens_in_game():
		token.routes.clear()
		token.routes = get_routes(
			token, dice_value
		)

		if not token.routes.is_empty():
			active_tokens.append(token)

	return active_tokens

func get_routes(
	token:TokenClass,
	dice_value:int,
) -> Dictionary:

	var routes:Dictionary = {}
	
	# Usar un diccionario para pasar por "referencia"
	var search_state:Dictionary = {
		"goal_finded": false,
		"goal_route": []
	}
	
	# Verificar si la token comienza en una conexión
	var is_init_conexion:bool = (
		token.current_tile in current_nucleus.board_conexions or
		token.current_tile in current_nucleus.board_conexions.values()
	)
	
	var blocked_conexion = token.last_conexion_used
	var _special_game = false
	
	# Si comienza en una conexión y NO es la que usó en el turno anterior
	if is_init_conexion and token.current_tile != blocked_conexion:
		# Puede cambiar de current_board inmediatamente
		# Buscamos la conexión opuesta
		var other_target:TileClass = null
		
		if token.current_tile in current_nucleus.board_conexions:
			# Es una entrance del núcleo → la exit está en el current_board
			other_target = current_nucleus.board_conexions[token.current_tile]
		else:
			# Es una exit del núcleo → la entrance está en el núcleo
			for entrance in current_nucleus.board_conexions:
				if current_nucleus.board_conexions[entrance] == token.current_tile:
					other_target = entrance
					break
		
		if other_target != null:
			# Comenzamos desde la otra punta de la conexión
			_special_game = true
			var init_route:Array[TileClass] = [other_target]
			
			# Verificar si la otra punta es la tile de exit
			if other_target == token.owner_player.spawn_tile:
				search_state["goal_finded"] = true
				search_state["goal_route"] = init_route
			else:
				# Reiniciar estado para esta búsqueda
				var temp_state:Dictionary = {
					"goal_finded": false,
					"goal_route": []
				}
				
				search_route(
					token,
					init_route,
					dice_value - 1,  # Ya usamos 1 paso para cambiar de current_board
					other_target,
					routes,
					token.current_tile,  # Esta conexión queda bloqueada ahora
					temp_state
				)
				
				if temp_state["goal_finded"]:
					search_state["goal_finded"] = true
					search_state["goal_route"] = temp_state["goal_route"]
	
	# También buscar routes normales (sin cambio inmediato)
	# IMPORTANTE: Siempre buscar routes normales, incluso si está en conexión
	# Esto arregla el problema de que con dice_value = 1 no muestra la opción de seguir en el mismo current_board
	if not search_state["goal_finded"]:  # Solo buscar si no encontramos exit ya
		# Ruta vacía inicial para movimiento normal
		var init_route:Array[TileClass] = []
		
		# Reiniciar estado para esta búsqueda
		var temp_state:Dictionary = {
			"goal_finded": false,
			"goal_route": []
		}
		
		search_route(
			token,
			init_route,
			dice_value,
			token.current_tile,
			routes,
			blocked_conexion,
			temp_state
		)
		
		if temp_state["goal_finded"]:
			search_state["goal_finded"] = true
			search_state["goal_route"] = temp_state["goal_route"]
	
	# Si encontramos la exit, limpiar todas las otras routes
	if search_state["goal_finded"]:
		routes.clear()
		routes[token.owner_player.spawn_tile] = search_state["goal_route"]
	
	return routes

func search_route(
	token:TokenClass,
	current_route:Array[TileClass],
	remaining_steps:int,
	current_tile:TileClass,
	routes:Dictionary,
	blocked_conexion:TileClass = null,
	search_state:Dictionary = {}
) -> void:

	# Si ya encontramos la exit en otra rama, no continuar
	if search_state.get("goal_finded", false):
		return

	# Solo agregamos al diccionario cuando terminamos los pasos
	if remaining_steps == 0:
		# IMPORTANTE: Verificamos si la tile actual ES la exit
		if current_tile == token.owner_player.spawn_tile:
			# ¡Encontramos la exit en el último paso!
			var last_route = current_route.duplicate()
			search_state["goal_finded"] = true
			search_state["goal_route"] = last_route
		elif _free_tile(token, current_tile):
			var last_route = current_route.duplicate()

			if not routes.has(current_tile):
				# Primera route a esta tile
				routes[current_tile] = last_route
			else:
				# Comparar directez
				var already_route = routes[current_tile]

				var already_route_changes = _count_board_changes(already_route)
				var new_route_changes = _count_board_changes(last_route)

				if new_route_changes < already_route_changes:
					routes[current_tile] = last_route

		return

	var way_points:Array[TileClass]
	var is_board:bool

	if current_tile.tile_type == GameConstants.TILE_TYPES.BOARD:
		way_points = current_board.casillas_internas
		is_board = true
	else:
		way_points = current_nucleus.casillas
		is_board = false

	# ───── 1️⃣ AVANZAR SIEMPRE ─────
	var idx := current_tile.tile_index
	var next := way_points[(idx + 1) % way_points.size()]

	# Creamos nueva route agregando la next tile
	var new_route := current_route.duplicate()
	new_route.append(next)

	# Verificar si la next tile es la exit ANTES de continuar
	if next == token.owner_player.spawn_tile:
		# ¡Encontramos la exit! Guardar esta route
		var last_route = new_route.duplicate()
		search_state["goal_finded"] = true
		search_state["goal_route"] = last_route
		return  # Cortar la búsqueda - encontramos la meta

	# Continuar por el mismo way_points solo si no es la exit
	search_route(
		token,
		new_route,
		remaining_steps - 1,
		next,
		routes,
		blocked_conexion,
		search_state
	)

	# Si ya encontramos la exit, no explorar más
	if search_state.get("goal_finded", false):
		return

	# ───── 2️⃣ VERIFICAR CAMBIO DE TABLERO (2 pasos) ─────
	# Solo podemos cambiar de current_board si tenemos al menos 2 pasos restantes
	if remaining_steps >= 2:
		var entrance_conexion:TileClass = null
		var exit_conexion:TileClass = null
		
		if is_board:
			# Tablero → Núcleo
			for entrance in current_nucleus.board_conexions.keys():
				var exit = current_nucleus.board_conexions[entrance]
				if exit == next:
					# Verificar si esta conexión está bloqueada
					# NO puede ser la misma que ya usó
					if entrance != blocked_conexion:
						entrance_conexion = next
						exit_conexion = entrance
					break
		else:
			# Núcleo → Tablero
			if next in current_nucleus.board_conexions.keys():
				var exit = current_nucleus.board_conexions[next]
				# Verificar si esta conexión está bloqueada
				# NO puede ser la misma que ya usó
				if exit != blocked_conexion:
					entrance_conexion = next
					exit_conexion = exit

		# Si encontramos una conexión válida, explorar ese way_points (2 pasos)
		if entrance_conexion != null and exit_conexion != null:
			# Creamos una route que incluya ambos pasos
			var route_conexion := current_route.duplicate()
			route_conexion.append(entrance_conexion)
			
			var with_exit_route := route_conexion.duplicate()
			with_exit_route.append(exit_conexion)
			
			# Verificar si la conexión de exit es la tile de exit
			if exit_conexion == token.owner_player.spawn_tile:
				var last_route = with_exit_route.duplicate()
				search_state["goal_finded"] = true
				search_state["goal_route"] = last_route
				return
			
			# IMPORTANTE: La nueva conexión bloqueada es la que estamos usando
			# para entrar al otro current_board (exit_conexion si vamos al núcleo,
			# entrance_conexion si vamos al current_board)
			var new_blocked_conexion:TileClass
			if is_board:
				new_blocked_conexion = exit_conexion  # Entrada al núcleo
			else:
				new_blocked_conexion = entrance_conexion  # Entrada del núcleo
			
			# Llamamos recursivamente con remaining_steps - 2
			search_route(
				token,
				with_exit_route,
				remaining_steps - 2,
				exit_conexion,
				routes,
				new_blocked_conexion,
				search_state
			)

func _free_tile(
	searching_token:TokenClass,
	tile:TileClass
) -> bool:

	# La tile de exit SIEMPRE está disponible
	if tile == searching_token.owner_player.spawn_tile:
		return true

	if not tile.fichas.is_empty():
		var last_token_in:TokenClass = tile.fichas[-1]
		if (
				(tile.habilidad == GameConstants.TILE_HABILITY.PROTECTION \
				and (tile.hability_team == GameConstants.PLAYERS_TEAM.ALL or\
				tile.hability_team == last_token_in.owner_player.team)) or\
				
				(searching_token.owner_player == last_token_in.owner_player)
		):
			return false

	return true

func _count_board_changes(route:Array[TileClass]) -> int:
	if route.is_empty():
		return 0

	var changes := 0
	var last_type = route[0].tile_type

	for tile in route:
		if tile.tile_type != last_type:
			changes += 1
			last_type = tile.tile_type

	return changes

	
func follow_route(
	dice:TokenClass,
	selected_token:TokenClass,
	selected_tile:TileClass
) -> void:

	# Obtener la route seleccionada
	var selected_route = selected_token.routes.get(selected_tile, [])
	if selected_route.is_empty():
		print("Error: Ruta vacía o no encontrada para la tile seleccionada")
		return
	
	
	# Variables para rastrear el estado durante el movimiento
	var ancled_tokens:Array[TokenClass] = selected_token.current_tile.fichas.duplicate()
	var last_tile:TileClass = selected_token.current_tile
	var used_conexion: TileClass = null
	var already_change_board: bool = false

	# Si la tile seleccionada es la tile de exit, 
	# tenemos un comportamiento especial
	var is_goal_tile: bool = (selected_tile == selected_token.owner_player.spawn_tile)

	# Animar el recorrido paso a paso
	for tile:TileClass in selected_route:
		
		# Verificar si estamos cambiando de current_board
		# (comparamos con la última tile antes de mover)
		if last_tile.tile_type != tile.tile_type:
			# Esta es una conexión entre tableros
			used_conexion = tile
			already_change_board = true
			
			# Determinar a qué current_board pertenece esta tile
			if tile.tile_type == GameConstants.TILE_TYPES.NUCLEUS:
				for token in ancled_tokens:
					token.reparent(current_nucleus)
				print("Ficha cambiada al núcleo en conexión: ", tile.tile_index)
			else:
				for token in ancled_tokens:
					token.reparent(current_board)
				print("Ficha cambiada al current_board en conexión: ", tile.tile_index)
		
		# Mover a la tile (animación)
		print("Moviendo token a tile: ", tile.tile_index)

		for i in range(ancled_tokens.size()-1, -1, -1):
			ancled_tokens[i].set_z_index(25 + 51*(i+1))
			print(ancled_tokens[i].get_z_index())
		
		for token in ancled_tokens:
			token.move_to_tile(tile)
			await Engine.get_main_loop().create_timer(0.1).timeout
		
		await ancled_tokens[-1].animable.animacion_terminada
		
		# Verificar si llegamos a la tile de exit
		if is_goal_tile and tile == selected_token.owner_player.spawn_tile:
			print("¡Ficha llegó a su tile de exit!")
			# Podríamos agregar efectos especiales aquí si es necesario
			break
		
		# Actualizar la última tile para la next iteración
		last_tile = tile

	# Actualizar la última conexión usada SOLO si realmente cambiamos de current_board
	if already_change_board:
		selected_token.last_conexion_used = used_conexion
		print("Conexión bloqueada para next turno: ", 
			  str(used_conexion.tile_index) if used_conexion else "ninguna")
	else:
		selected_token.last_conexion_used = null
	
	GameResources.tile_solver.land_in_tile(dice, selected_token, 
	selected_tile)
	
	# Emitir señal de que la token fue posicionada
	placed_token.emit()

	# Limpiar routes después de usarlas
	selected_token.routes.clear()
