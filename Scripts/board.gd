extends Sprite2D
class_name BoardClass

var int_tiles : Array[TileClass] = []
var out_tiles : Array[TileClass] = []

func _ready():
	_reasign_tiles()

func _reasign_tiles():
	int_tiles.clear()
	out_tiles.clear()

	var index = 0
	for node in get_tree().get_nodes_in_group("Board Tile"):
		if node is TileClass:
			int_tiles.append(node)
			node.tile_index = index
		index += 1
		
	index = 0		
	for node in get_tree().get_nodes_in_group("Base Tile"):
		
		if node is TileClass:
			out_tiles.append(node)
			node.tile_index = index
		index+= 1
				
func get_player_bases(base_index:int = 0) -> Array[TileClass]:
	var bases:Array[TileClass] = []
	for i in range(GameConfiguration.player_tokens_number):
		var new_base:TileClass = out_tiles[(base_index+i-2)%out_tiles.size()]
		bases.append(new_base)
	return bases

func get_player_spawn(base_index:int = 0) -> TileClass:
	var player_spawn:TileClass = int_tiles[base_index]
	return player_spawn
		
	
	
