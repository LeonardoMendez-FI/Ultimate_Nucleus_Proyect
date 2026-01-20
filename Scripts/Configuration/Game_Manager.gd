extends Node2D
class_name Game_Manager

#DEBUG
@export var iniciar_juego:bool = false:
	set(value):
		iniciar_juego = false
		if value:
			_start_machine()
			
@export var active_players_number:int = 4:
	set(value):
		GameConfiguration.active_players_number = value

@export var active_bots_number:int = 0:
	set(value):
		GameConfiguration.active_bots_number = value

@export var bots_dificult:= GameConstants.BOTS_DIFICULT.MEDIUM:
	set(value):
		GameConfiguration.bots_dificult = value

@export var nucleus_shape:= GameConstants.NUCLEUS_SHAPES.Triangle:
	set(value):
		GameConfiguration.nucleus_shape = value

# VARIABLE

@onready var state_machine:StateMachine = $Game_States
@onready var players_solver:Players_Solver = $Components/Jugadores
@onready var nucleus_solver:Nucleus_Solver = $Components/Nucleus_Solver

@onready var tablero:BoardClass = $Components/Tablero
@onready var fondo:Background = $Components/Background
@onready var dados:Array = $Components/Dados.get_children()
@onready var boton_tirar:SelectableButton = $Components/Botones/Boton_Tirar
@onready var boton_girar:SelectableButton = $Components/Botones/Boton_Girar

var ficha_seleccionada:TokenClass = null
var dado_seleccionado:TokenClass = null
var casilla_seleccionada:TileClass = null

#region configuracion inicial
	
func _post_ready() -> void:
	call_deferred("_ready")
	
func _start_machine() -> void:
	state_machine.start(self)
	
func _init_game() -> void:
	
	_configurate_tablero()
	_conectar_señales()
	
	for dado:TokenClass in dados:
		dado.selectable = false
	
	boton_girar.selectable = false
	boton_tirar.selectable = false
	

func _configurate_tablero() -> void:
	
	nucleus_solver.current_nucleus.conectar_con_tablero(tablero)
	
	GameResources.tile_solver.tablero = tablero
	GameResources.tile_solver.nucleus = nucleus_solver.current_nucleus
	GameResources.movement_solver.tablero = tablero
	GameResources.movement_solver.nucleus = nucleus_solver.current_nucleus
	
	for jugador in players_solver.players:
		var bases = tablero.obtener_bases_jugador(jugador.index_base)
		var salida = tablero.obtener_salida_jugador(jugador.index_base)
		
		jugador.configurate(bases, salida)
		for ficha in jugador.fichas:
			tablero.add_child(ficha)

#endregion


#region Señales

func _conectar_señales() -> void:
	
	for dado:TokenClass in dados:
		dado.select_signal.connect(_on_dado_selected)
	
	players_solver.current_player_changed.connect(_on_player_changed)
	
	for jugador:PlayerClass in players_solver.players:
		for ficha in jugador.fichas:
			ficha.select_signal.connect(_on_ficha_selected)
			
	boton_tirar.select_signal.connect(_on_boton_tirar_selected)
	boton_girar.select_signal.connect(_on_boton_girar_selected)
	
	for casilla:TileClass in tablero.casillas_internas:
		casilla.select_signal.connect(_on_casilla_selected)
	
	for casilla:TileClass in nucleus_solver.current_nucleus.casillas:
		casilla.select_signal.connect(_on_casilla_selected)
				
#region funciones señales

func _on_dado_selected(dado_selected:TokenClass) -> void:
	
	if dado_selected.selected:
		if dado_seleccionado and dado_seleccionado != dado_selected:
			dado_seleccionado.selected = false
		dado_seleccionado = dado_selected
		state_machine._change_to(GameConstants.GAME_STATES.Dado_Seleccionado)
	else:
		state_machine._change_to(GameConstants.GAME_STATES.Dados_Tirados)
			
func _on_boton_girar_selected(_boton)-> void:
	state_machine._change_to(GameConstants.GAME_STATES.Ultima_Accion)

func _on_boton_tirar_selected(_boton) -> void:
	for dado:TokenClass in dados:
		dado.lanzar()
	state_machine._change_to(GameConstants.GAME_STATES.Dados_Tirados)

func _on_casilla_selected(casilla_selected:TileClass) -> void:
	casilla_seleccionada = casilla_selected
	state_machine._change_to(GameConstants.GAME_STATES.Ultima_Accion)
		
func _on_ficha_selected(ficha_select:TokenClass)-> void:
	
	if ficha_select.selected:
		if ficha_seleccionada and ficha_seleccionada != ficha_select:
			ficha_seleccionada.selected = false
			
		ficha_seleccionada = ficha_select
		if ficha_select.is_in_base():
			state_machine._change_to(GameConstants.GAME_STATES.Ficha_Sacada)
		else:
			state_machine._change_to(GameConstants.GAME_STATES.Ficha_Seleccionada)
	else:
		state_machine._change_to(GameConstants.GAME_STATES.Dado_Seleccionado)		

func _on_player_changed(player:PlayerClass) -> void:
	state_machine._change_to(GameConstants.GAME_STATES.Nuevo_Turno)
	fondo.actualizar_color_fondo(player.color)
	
#endregion

#endregion
	
	
