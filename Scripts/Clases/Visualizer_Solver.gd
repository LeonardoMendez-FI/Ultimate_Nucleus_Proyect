extends Node
class_name Visualizer_Solver

const center:Vector2 = Vector2.ZERO

func obtener_rotacion(pos_actual:Vector2) -> float:
	var angulo:float
	angulo = (pos_actual - center).angle()
	
	return angulo
