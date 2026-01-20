extends Node
class_name TilesSolver

var current_board:BoardClass = null
var current_nucleus:NucleusClass = null

func land_in_tile(current_dice:TokenClass, current_token:TokenClass, current_tile:TileClass):

	tile_capture(current_token)
	
	if current_tile == current_token.owner_player.goal_tile:
		finish_race(current_token)
		
	else:
		match(current_tile.hability):
			GameConstants.TILE_HABILITY.STANDARD:
				pass
			GameConstants.TILE_HABILITY.DOUBLE:
				current_dice.lanzar()
				await current_dice.animable.finished_animation
			GameConstants.TILE_HABILITY.NUCLEUS_SPIN:
				current_nucleus.spin(current_dice.value)
				await current_nucleus.animable.finished_animation
			GameConstants.TILE_HABILITY.PROTECTION:
				pass
			_:
				current_token.owner_player.score += 1
		
func tile_capture(current_token:TokenClass) -> void:
	
	for token:TokenClass in current_token.current_tile.tokens_in.slice(0, -1):
		if token.owner_player == current_token.owner_player:
			return_to_base(token)
		else:
			token.captured = true

func finish_race(current_token:TokenClass) -> void:
	current_token.owner_player.score += current_token.owner_player.goal_tile.tokens_in.size() + 1
	
	for token in current_token.owner_player.goal_tile.tokens_in.duplicate():
		return_to_base(token)
		
func return_to_base(token:TokenClass) -> void:
	token.return_to_base()
	token.reparent(current_board)
	await token.animable.finished_animation
	
func add_token(token:TokenClass, tile:TileClass) -> void:
	tile.tokens_in.append(token)
	token.z_index += tile.tokens_in.size() + 2
	token.current_tile = tile

func remove_token(token:TokenClass, tile:TileClass) -> void:
	tile.tokens_in.erase(token)
