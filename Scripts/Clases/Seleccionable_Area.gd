extends Area2D
class_name Selectionable_Area

signal select_signal(valor:bool)

var select : bool = false:
	set(value):
		if value:
			global_scale = Vector2(1.2, 1.2)
			select = true
		else:
			global_scale = Vector2.ONE
			select = false
		_actualizar_estado_visual()
			
var selectable : bool = false:
	set(value):
		if not value:
			global_scale = Vector2.ONE
			select = false
		selectable = value
		input_pickable = value
		_actualizar_estado_visual()
			
func _ready() -> void:
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	_actualizar_estado_visual()

func _on_mouse_entered():
	if selectable:
		global_scale = Vector2(1.2, 1.2)

func _on_mouse_exited():
	if selectable and !select:
		global_scale = Vector2.ONE
		
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		if selectable:
			seleccionar()

func seleccionar() -> void:
	select = !select
	_actualizar_estado_visual()
	emit_signal("select_signal", self)

func _actualizar_estado_visual() -> void:
	pass
