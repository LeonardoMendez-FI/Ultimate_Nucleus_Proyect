extends Area2D
class_name SelectableArea

signal selected_signal(valor:bool)

var selected : bool = false:
	set(value):
		if value:
			global_scale = Vector2(1.2, 1.2)
			selected = true
		else:
			global_scale = Vector2.ONE
			selected = false
		_update_visual_state()
			
var selectable : bool = false:
	set(value):
		if not value:
			global_scale = Vector2.ONE
			selected = false
		selectable = value
		input_pickable = value
		_update_visual_state()
			
func _ready() -> void:
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	_update_visual_state()

func _on_mouse_entered():
	if selectable:
		global_scale = Vector2(1.2, 1.2)

func _on_mouse_exited():
	if selectable and !selected:
		global_scale = Vector2.ONE
		
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		if selectable:
			select()

func select() -> void:
	selected = !selected
	_update_visual_state()
	emit_signal("selected_signal", self)

func _update_visual_state() -> void:
	pass
