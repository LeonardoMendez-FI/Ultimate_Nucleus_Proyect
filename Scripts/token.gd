extends SelectableArea
class_name TokenClass

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@export_dir var dir_sprites
@onready var animable:Animable = $Animable

var owner_player:PlayerClass = null
var captured:bool = false
var routes:Dictionary = {} # Dictionary[TileClass, Array[TileClass]]
var base_tile:TileClass = null
var current_tile:TileClass = null
var last_conexion_used: TileClass = null

#region configuracion
func configurate(player:PlayerClass, base:TileClass) -> void:
	owner_player = player
	sprite.sprite_frames = sprite.sprite_frames.duplicate()
	_sprites_load()
	base_tile = base
	return_to_base()

func _ready() -> void:
	super._ready()
	
func _sprites_load():
	
	var routes_dict : Dictionary = {"Standard":"/StandarToken_", 
	"Selectable":"/SelectableToken_","Selected":"/StandarToken_"}
	
	var frames := sprite.sprite_frames
	
	for anim_name in frames.get_animation_names():
		if not routes_dict.has(anim_name):
			continue
			
		frames.clear(anim_name) # borra SOLO los frames
		frames.add_frame(anim_name, load(dir_sprites + routes_dict[anim_name]\
		 + GameConstants.STR_PLAYERS_TEAM[owner_player.color] + ".png"))	
	
func _update_visual_state() -> void:
	
	if selected:
		show_routes(true)
		sprite.play("Selected")
	else:
		show_routes(false)
		if selectable:
			sprite.play("Selectable")
		else:
			sprite.play("Standard")

#endregion

#region estado actual
func is_in_base() -> bool:
	if current_tile.tile_type == GameConstants.TILE_TYPES.BASE:
		return true
	else:
		return false

func is_in_game() -> bool:
	if !is_in_base() and !captured:
		return true
	else:
		return false

#endregion

#region movimiento ficha
func return_to_base() -> void:
	move_to_tile(base_tile)
	captured = false
	routes.clear()
	last_conexion_used = null

func spawn() -> void:
	move_to_tile(owner_player.spawn_tile)
	GameResources.tile_solver.tile_capture(self)
	
func move_to_tile(target_tile: TileClass) -> void:
		
	if current_tile:
		if current_tile and base_tile and is_in_base():
			GameResources.visualizer_solver.token_spawn_animate(self, target_tile, animable)
		else:
			GameResources.visualizer_solver.token_move_animate(self, target_tile, animable)
			
		GameResources.tile_solver.remove_token(self, current_tile)
	else:
		GameResources.visualizer_solver.token_move_animate(self, target_tile, animable)

	GameResources.tile_solver.add_token(self, target_tile)

#endregion

#region routes

func show_routes(show_tile:bool = true) -> void:
	
	if routes.is_empty():
		return
	
	for target:TileClass in routes:
		for tile in routes[target]:
			tile.in_rute = show_tile
		target.selectable = show_tile

func _on_mouse_entered():
	super._on_mouse_entered()
	show_routes(selectable)

func _on_mouse_exited():
	super._on_mouse_exited()
	show_routes(selectable and selected)
		
#endregion
