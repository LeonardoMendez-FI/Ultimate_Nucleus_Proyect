extends Control
class_name PlayerClass

@export var team:= GameConstants.PLAYERS_TEAM.ALL
@export var index_base:int = 0
@onready var state_machine:StateMachine = $PlayerStateMachine
@onready var sprite:= $MarginContainer/TextureRect

var spawn_tile:TileClass = null
var own_tokens:Array[TokenClass] = []
var score:int = 0

func _ready() -> void:
	state_machine.start(self)
	
func configurate(bases, spawn) -> void:
	spawn_tile = spawn
	spawn_tile.hability_team = team
	spawn_tile.hability = GameConstants.TILE_HABILITY.SPAWN
	tokens_creator(bases)

func tokens_creator(bases:Array) -> void:
	
	const token_scene = preload(GameScenes.token_scene)
	for i in range(GameConfiguration.active_players_number):
		
		var new_token:TokenClass = token_scene.instantiate()
		new_token.call_deferred("configurate", self, bases[i])
		own_tokens.append(new_token)
		
func tokens_in_base() -> Array[TokenClass]:
	var base_tokens:Array[TokenClass] = []
	for token in own_tokens:
		if token.is_in_base():
			base_tokens.append(token)
	return base_tokens

func tokens_in_game() -> Array[TokenClass]:
	var active_tokens:Array[TokenClass] = []
	for token in own_tokens:
		if token.is_in_game():
			active_tokens.append(token)
	return active_tokens
