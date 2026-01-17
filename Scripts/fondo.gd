extends Node2D
class_name Fondo

@export_dir var dir_sprites

func _ready() -> void:
	pass # Replace with function body.

func actualizar_color_fondo(color_jugador: String) -> void:
	
	var ruta_sprite = dir_sprites + "/FondoJugador" + color_jugador.capitalize() + ".png"
	$Fondo_Nuevo.texture = load(ruta_sprite)
	$Fondo_Nuevo.modulate.a = 0.0
	$Fondo_Nuevo.visible = true
	
	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property($Fondo_Actual, "modulate:a", 0.0, 1.0)
	tween.tween_property($Fondo_Nuevo, "modulate:a", 1.0, 1.0)

	tween.finished.connect(func():
		$Fondo_Actual.texture = $Fondo_Nuevo.texture
		$Fondo_Actual.modulate.a = 1.0
		$Fondo_Nuevo.visible = false
	)
