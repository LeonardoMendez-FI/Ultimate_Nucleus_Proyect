extends Selectionable_Area
class_name Dado_Estandar

var valor:int = 1
@onready var sprite_dado:AnimatedSprite2D = $AnimatedSprite2D
@onready var animable:Animable = $Animable

var lanzando := false

# -------------------------------------------------
# LANZAMIENTO CON TWEEN
# -------------------------------------------------
func lanzar() -> void:
	if lanzando:
		return

	lanzando = true
	selectable = false
	select = false
	_actualizar_estado_visual()

	animable.play(func(tween):
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		var dur := 0.07 #0.07

		for i in range(2):
			_giro_horizontal(tween, dur)
			_giro_vertical(tween, dur)
			_giro_horizontal(tween, dur)
			_giro_vertical(tween, dur)

		_micro_rebote(tween)
		_rotacion_final(tween)
	)

	animable.animacion_terminada.connect(
		_resultado_final,
		CONNECT_ONE_SHOT
	)

func _giro_horizontal(tween: Tween, dur: float) -> void:
	tween.tween_property(self, "scale:x", 0.05, dur)
	tween.tween_callback(_cambiar_valor_aleatorio)
	tween.tween_property(self, "scale:x", 1.0, dur)

func _giro_vertical(tween: Tween, dur: float) -> void:
	tween.tween_property(self, "scale:y", 0.05, dur)
	tween.tween_callback(_cambiar_valor_aleatorio)
	tween.tween_property(self, "scale:y", 1.0, dur)

func _micro_rebote(tween: Tween) -> void:
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "scale", Vector2(1.15, 0.85), 0.08)
	tween.tween_property(self, "scale", Vector2(0.95, 1.05), 0.06)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08)

func _rotacion_final(tween: Tween) -> void:
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "rotation", deg_to_rad(12), 0.08)
	tween.tween_property(self, "rotation", deg_to_rad(-8), 0.06)
	tween.tween_property(self, "rotation", 0.0, 0.08)

func _cambiar_valor_aleatorio() -> void:
	valor = GameResources.azar.randi_range(1, 6)
	_actualizar_estado_visual()

func _resultado_final() -> void:
	valor = GameResources.azar.randi_range(1, 6)
	scale = Vector2.ONE
	lanzando = false
	selectable = true

func _actualizar_estado_visual() -> void:
	if not selectable and not lanzando and not select:
		visible = false
		return
	
	visible = true
	var estado := "Seleccionado_" if select else "Estandar_"
	sprite_dado.play(estado + str(valor))
