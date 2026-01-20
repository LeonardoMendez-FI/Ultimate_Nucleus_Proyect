extends Node2D
class_name Background

@export_dir var dir_sprites

func _ready() -> void:
	pass # Replace with function body.

func actualizar_team_fondo(team:GameConstants.PLAYERS_TEAM) -> void:
	
	var ruta_sprite = dir_sprites + "/FondoJugador" + GameConstants.STR_PLAYERS_TEAM[team] + ".png"
	$New_Background.texture = load(ruta_sprite)
	$New_Background.modulate.a = 0.0
	$New_Background.visible = true
	
	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property($Current_Background, "modulate:a", 0.0, 1.0)
	tween.tween_property($New_Background, "modulate:a", 1.0, 1.0)

	tween.finished.connect(func():
		$Current_Background.texture = $New_Background.texture
		$Current_Background.modulate.a = 1.0
		$New_Background.visible = false
	)
