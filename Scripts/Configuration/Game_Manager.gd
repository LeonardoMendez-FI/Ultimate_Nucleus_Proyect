extends Node2D
class_name Game_Manager

@onready var state_machine:StateMachine = $Game_States
@onready var jugadores: Array = $Componentes/Jugadores.get_children()
@onready var tablero:Tablero = $Componentes/Tablero
@onready var nucleus:Nucleus = $Componentes/Nucleus
@onready var fondo:Fondo = $Componentes/Fondo
@onready var dados:Array = $Componentes/Dados.get_children()
@onready var boton_tirar:Selectionable_Button = $Componentes/Botones/Boton_Tirar
@onready var boton_girar:Selectionable_Button = $Componentes/Botones/Boton_Girar

var jugador_en_turno:Jugador
var ficha_seleccionada:FichaEstandar = null
var dado_seleccionado:Dado_Estandar = null
var casilla_seleccionada:Casilla = null

#region configuracion inicial

func _post_ready() -> void:
	call_deferred("_ready")
	
func _ready() -> void:
	state_machine.start(self)
	
func _inicializar_juego() -> void:
	
	_configurar_tablero()
	_conectar_señales()
	
	for dado:Dado_Estandar in dados:
		dado.selectable = false
	
	boton_girar.selectable = false
	boton_tirar.selectable = false
	
	for jugador:Jugador in jugadores:
		for ficha:FichaEstandar in jugador.fichas:
			ficha.selectable = false
		
		if jugador.get_index() > GameConfiguration.numero_jugadores_activos:
			jugador.activo = false
	
	jugador_en_turno = jugadores[0]
	

func _configurar_tablero() -> void:
	nucleus.configurar()
	nucleus.conectar_con_tablero(tablero)
	
	GameResources.casilla_solver.tablero = tablero
	GameResources.casilla_solver.nucleus = nucleus
	GameResources.movement_solver.tablero = tablero
	GameResources.movement_solver.nucleus = nucleus
	
	for jugador in jugadores:
		var bases = tablero.obtener_bases_jugador(jugador.index_base)
		var salida = tablero.obtener_salida_jugador(jugador.index_base)
		
		jugador.configurar(bases, salida)
		for ficha in jugador.fichas:
			tablero.add_child(ficha)

#endregion


#region Señales

func _conectar_señales() -> void:
	
	for dado in dados:
		dado.select_signal.connect(_on_dado_selected)
		
	for jugador in jugadores:
		for ficha in jugador.fichas:
			ficha.select_signal.connect(_on_ficha_selected)
			
	boton_tirar.select_signal.connect(_on_boton_tirar_selected)
	boton_girar.select_signal.connect(_on_boton_girar_selected)
	
	for casilla in tablero.casillas_internas:
		casilla.select_signal.connect(_on_casilla_selected)
		
	for casilla in nucleus.casillas:
		casilla.visible = true
		casilla.select_signal.connect(_on_casilla_selected)
	
#region funciones señales

func _on_dado_selected(dado_selected:Dado_Estandar) -> void:
	
	if dado_selected.select:
		if dado_seleccionado and dado_seleccionado != dado_selected:
			dado_seleccionado.select = false
		dado_seleccionado = dado_selected
		state_machine._change_to(GameConstants.GAME_STATES.Dado_Seleccionado)
	else:
		state_machine._change_to(GameConstants.GAME_STATES.Dados_Tirados)
			
func _on_boton_girar_selected(_boton)-> void:
	state_machine._change_to(GameConstants.GAME_STATES.Ultima_Accion)

func _on_boton_tirar_selected(_boton) -> void:
	for dado:Dado_Estandar in dados:
		dado.lanzar()
	state_machine._change_to(GameConstants.GAME_STATES.Dados_Tirados)

func _on_casilla_selected(casilla_selected:Casilla) -> void:
	casilla_seleccionada = casilla_selected
	state_machine._change_to(GameConstants.GAME_STATES.Ultima_Accion)
		
func _on_ficha_selected(ficha_select:FichaEstandar)-> void:
	
	if ficha_select.select:
		if ficha_seleccionada and ficha_seleccionada != ficha_select:
			ficha_seleccionada.select = false
			
		ficha_seleccionada = ficha_select
		if ficha_select.is_in_base():
			state_machine._change_to(GameConstants.GAME_STATES.Ficha_Sacada)
		else:
			state_machine._change_to(GameConstants.GAME_STATES.Ficha_Seleccionada)
	else:
		state_machine._change_to(GameConstants.GAME_STATES.Dado_Seleccionado)		
	
#endregion

#endregion
	
	
