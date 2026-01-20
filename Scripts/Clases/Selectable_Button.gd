extends SelectableArea
class_name SelectableButton

func select() -> void:
	super.select()
	selectable = false
	
func update_visual_state() -> void:
	visible = selectable
