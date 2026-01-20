@tool
extends SelectableArea
class_name TileClass

@export var hability := GameConstants.TILE_HABILITY.STANDARD:
	set(value):
		hability = value
		_sprites_load()
		_update_visual_state()
		
@export var hability_team := GameConstants.PLAYERS_TEAM.ALL:
	set(value):
		hability_team = value
		_sprites_load()
		_update_visual_state()
		
@export var tile_type: = GameConstants.TILE_TYPES.BOARD:
	set(value):
		tile_type = value
		_sprites_load()
		_update_visual_state()
		
@export_dir var dir_sprites

@export var sprite : Sprite2D
@export var icon : AnimatedSprite2D

@export var tile_index : int = 0:
	set(value):
		tile_index = value
		$Label.text = str(tile_index)
var tokens_in:Array[TokenClass] = []

var _ready_called = false

var in_rute:bool = false: 
	set(value):
		in_rute = value
		_update_visual_state()


func _process(_delta: float) -> void:
	if GameResources.visualizer_solver.arranging:
		return
	GameResources.visualizer_solver.arrange_visual_token(self)

func _ready() -> void:
	super._ready()
	set_process(false)
	_ready_called = true
	_sprites_load()
	
# FACTORY CASILLA
func configurate(args := {}) -> void:
	tile_index = args.get("index", 0)
	tile_type = args.get("type", GameConstants.TILE_TYPES.BOARD)
	hability = args.get("hability", GameConstants.TILE_HABILITY.STANDARD)
	hability_team = args.get("team", GameConstants.PLAYERS_TEAM.ALL)
	global_position = args.get("current_position", Vector2.ZERO)
	selectable = args.get("selectable", false)
	global_rotation += args.get("radial_angle", 0)

func _sprites_load() -> void:
	
	if not _ready_called:
		return
		
	var strings_rute = [
		dir_sprites,
		GameConstants.STR_TILE_TYPES[tile_type],
		GameConstants.STR_TILE_HABILITY[hability],
		GameConstants.STR_PLAYERS_TEAM[hability_team]
	]
	
	var rute_sprite := "{0}/Sprite/Tile_{1}_{2}_{3}.png".format(strings_rute)
	if FileAccess.file_exists(rute_sprite):
		sprite.texture = load(rute_sprite)
	else:
		push_warning("No existe el archivo: " + rute_sprite)

func _on_nucleo_girando(girando:bool) -> void:
	if not tokens_in.is_empty() and girando:
		set_process(true)
		print("Process Activado")
	else:
		set_process(false)

func _update_visual_state() -> void:
	
	if not _ready_called:
		return
		
	if selectable:
		icon.play("Active")
	else:
		if in_rute:
			icon.play("In_Rute")
		else: 
			icon.play("Inactive")
	
