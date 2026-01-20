extends SelectableArea
class_name DiceClass

var value:int = 1
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var animable:Animable = $Animable

var rolling := false

# -------------------------------------------------
# LANZAMIENTO CON TWEEN
# -------------------------------------------------
func roll() -> void:
	if rolling:
		return

	rolling = true
	selectable = false
	selected = false
	_update_visual_state()

	animable.play(func(tween):
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		var dur := 0.07 #0.07

		for i in range(2):
			_horizontal_spin(tween, dur)
			_vertical_spin(tween, dur)
			_horizontal_spin(tween, dur)
			_vertical_spin(tween, dur)

		_mini_bounce(tween)
		_last_rotation(tween)
	)

	animable.animacion_terminada.connect(
		_last_value,
		CONNECT_ONE_SHOT
	)

func _horizontal_spin(tween: Tween, dur: float) -> void:
	tween.tween_property(self, "scale:x", 0.05, dur)
	tween.tween_callback(_cambiar_valor_aleatorio)
	tween.tween_property(self, "scale:x", 1.0, dur)

func _vertical_spin(tween: Tween, dur: float) -> void:
	tween.tween_property(self, "scale:y", 0.05, dur)
	tween.tween_callback(_cambiar_valor_aleatorio)
	tween.tween_property(self, "scale:y", 1.0, dur)

func _mini_bounce(tween: Tween) -> void:
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "scale", Vector2(1.15, 0.85), 0.08)
	tween.tween_property(self, "scale", Vector2(0.95, 1.05), 0.06)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08)

func _last_rotation(tween: Tween) -> void:
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "rotation", deg_to_rad(12), 0.08)
	tween.tween_property(self, "rotation", deg_to_rad(-8), 0.06)
	tween.tween_property(self, "rotation", 0.0, 0.08)

func _cambiar_valor_aleatorio() -> void:
	value = GameResources.luck.randi_range(1, 6)
	_update_visual_state()

func _last_value() -> void:
	value = GameResources.luck.randi_range(1, 6)
	scale = Vector2.ONE
	rolling = false
	selectable = true

func _update_visual_state() -> void:
	if not selectable and not rolling and not selected:
		visible = false
		return
	
	visible = true
	var state := "Selected_" if selected else "Standard_"
	sprite.play(state + str(value))
