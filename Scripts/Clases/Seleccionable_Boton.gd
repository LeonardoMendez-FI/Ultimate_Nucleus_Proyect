extends Selectionable_Area
class_name Selectionable_Button

func seleccionar() -> void:
	super.seleccionar()
	selectable = false
	
func _actualizar_estado_visual() -> void:
	visible=selectable
