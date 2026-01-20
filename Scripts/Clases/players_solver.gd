extends Control
class_name Players_Solver

signal current_player_changed(player:PlayerClass)

@onready var players:Array[PlayerClass] = [$JugadorMorado, $JugadorRojo, $JugadorVerde, $JugadorAzul]
var active_players:Array[PlayerClass]
var current_player:PlayerClass
var index_current_player:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_on_players_changed(GameConfiguration.active_players_number)
	_on_bots_changed(GameConfiguration.active_bots_number)
		
	GameConfiguration.active_players_changed.connect(_on_players_changed)
	GameConfiguration.active_bots_changed.connect(_on_bots_changed)

func _start_turn() -> void:
	index_current_player = GameResources.luck.randi_range(0,active_players.size())
	_next_turn()

func _next_turn() -> void:
	index_current_player = (index_current_player + 1) % active_players.size()
	current_player = active_players[index_current_player]
	current_player_changed.emit(current_player)

func _on_bots_changed(num_bots:int) -> void:
	for i in range(active_players.size()):
		var player = active_players[i]
		
		if i < active_players.size() - num_bots:
			player.state_machine._change_to(GameConstants.STR_PLAYER_STATES\
			[GameConstants.PLAYER_STATES.ACTIVE_PLAYER])
		else:
			player.state_machine._change_to(GameConstants.STR_PLAYER_STATES\
			[GameConstants.PLAYER_STATES.BOT_PLAYER] + "_" \
			+ GameConstants.STR_BOTS_DIFICULT[GameConfiguration.bots_dificult])
			

func _on_players_changed(num_players:int) -> void:
	
	active_players.clear()
	
	for i in range(players.size()):
		var player = players[i]
		if i < num_players:
			
			player.state_machine._change_to(GameConstants.STR_PLAYER_STATES\
			[GameConstants.PLAYER_STATES.ACTIVE_PLAYER])
			
			active_players.append(player)
		
		else:
			player.state_machine._change_to(GameConstants.PLAYER_STATES.INACTIVE_PLAYER)
