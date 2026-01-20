extends Sprite2D
class_name NucleusClass

@onready var animable = $Animable
@export var entrances_number:int

signal spining(it_is:bool)
var tiles_on: Array[TileClass] = []

var conected_board:BoardClass

# Primero: TileClass núcleo -> índice del tablero
# Después de conectar: TileClass núcleo -> TileClass tablero
var board_conexions: Dictionary = {}
	
func _ready() -> void:
	_reasign_tiles()

func _reasign_tiles():
	
	tiles_on.clear()
	
	var nodes := get_tree().get_nodes_in_group("Nucleus Tile")
	
	var i = 0
	for node in nodes:
		if node is TileClass:
			tiles_on.append(node)
			spining.connect(node._on_nucleo_girando)
			node.tile_index = i
			
			if node.is_in_group("Nucleus Vertex"):
				var entrance_idx := int(round(i * (36.0 / entrances_number))) % 36
				board_conexions[node] = entrance_idx		
		
		i += 1
# -------------------------------------------------
# CONEXIÓN CON TABLERO
# -------------------------------------------------
func board_conect(current_board: BoardClass) -> void:
	
	conected_board = current_board
	var new_conexions := {}

	for nucleus_tile in board_conexions.keys():
		var entrance_idx: int = board_conexions[nucleus_tile]

		if entrance_idx >= 0 and entrance_idx < current_board.int_tiles.size():
			new_conexions[nucleus_tile] = current_board.int_tiles[entrance_idx]
		else:
			print("⚠️ Índice inválido:", entrance_idx)
			new_conexions[nucleus_tile] = null

	board_conexions = new_conexions
	
	spin(GameResources.luck.randi_range(5, 15))

# -------------------------------------------------
# ROTACIÓN DEL NÚCLEO
# -------------------------------------------------
func spin(spin_tiles_number:int = 1) -> void:
	
	if !is_inside_tree():
		return
	if conected_board == null:
		return
	
	if is_queued_for_deletion():
		return
	spining.emit(true)

	var spin_angle := deg_to_rad(10 * spin_tiles_number)
	
	animable.play(func(tween):
		tween.tween_property(
		self,
		"rotation",
		rotation - spin_angle,
		spin_tiles_number*.4 #0.4
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	)
	
	animable.finished_animation.connect(
			_on_finished_spin.bind(spin_tiles_number),
		CONNECT_ONE_SHOT
	)

func _on_finished_spin(spin_tiles_number:int) -> void:
	
	if !is_instance_valid(self):
		return
	if conected_board == null:
		return
		
	# Ajustas conexiones lógicas aquí
	for nucleus_tile in board_conexions.keys():
		var board_tile: TileClass = board_conexions[nucleus_tile]
		if board_tile == null:
			continue

		var idx := conected_board.int_tiles.find(board_tile)
		var new_idx := (idx + spin_tiles_number) % conected_board.int_tiles.size()
		board_conexions[nucleus_tile] = conected_board.int_tiles[new_idx]

	spining.emit(false)
