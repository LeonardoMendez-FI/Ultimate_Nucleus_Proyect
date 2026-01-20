extends Node
class_name Animable

signal finished_animation

var tween: Tween

func play(tween_func: Callable) -> void:
	if tween:
		tween.kill()

	tween = get_parent().create_tween()
	tween_func.call(tween)

	tween.finished.connect(_on_finished)

func _on_finished() -> void:
	finished_animation.emit()
