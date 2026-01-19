extends Sprite2D
class_name Nucleus

@export var animable:Animable
@export var numero_entradas:int

signal girando(it_is:bool)
var casillas: Array[Casilla] = []

var tablero_conectado:Tablero

# Primero: Casilla núcleo -> índice del tablero
# Después de conectar: Casilla núcleo -> Casilla tablero
var entrada_salida: Dictionary = {}
	
func _ready() -> void:
	_reconstruir_casillas()

func _reconstruir_casillas():
	
	casillas.clear()
	
	var nodes := get_tree().get_nodes_in_group("Casilla Nucleus")
	
	nodes.sort_custom(func(a, b): return a.index_casilla < b.index_casilla)
	
	var i = 0
	for node in nodes:
		if node is Casilla:
			casillas.append(node)
			girando.connect(node._on_nucleo_girando)
			
			if node.is_in_group("Nucleus Vertice"):
				var entrada_idx := int(round(i * (36.0 / numero_entradas))) % 36
				entrada_salida[node] = entrada_idx		
		
		i += 1
# -------------------------------------------------
# CONEXIÓN CON TABLERO
# -------------------------------------------------
func conectar_con_tablero(tablero_global: Tablero) -> void:
	
	tablero_conectado = tablero_global
	var nuevas_conexiones := {}

	for casilla_nucleo in entrada_salida.keys():
		var entrada_idx: int = entrada_salida[casilla_nucleo]

		if entrada_idx >= 0 and entrada_idx < tablero_global.casillas_internas.size():
			nuevas_conexiones[casilla_nucleo] = tablero_global.casillas_internas[entrada_idx]
		else:
			print("⚠️ Índice inválido:", entrada_idx)
			nuevas_conexiones[casilla_nucleo] = null

	entrada_salida = nuevas_conexiones
	
	girar(GameResources.azar.randi_range(5, 15))

# -------------------------------------------------
# ROTACIÓN DEL NÚCLEO
# -------------------------------------------------
func girar(numero_casillas_giro:int = 1) -> void:
	
	if tablero_conectado == null:
		return
	
	girando.emit(true)
	#resaltar_vertices(false)
	#resaltar_conexiones_tablero(false)

	var angulo_giro := deg_to_rad(10 * numero_casillas_giro)
	
	animable.play(func(tween):
		tween.tween_property(
		self,
		"rotation",
		rotation - angulo_giro,
		numero_casillas_giro*.4 #0.4
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	)
	
	animable.animacion_terminada.connect(
			_on_giro_terminado.bind(numero_casillas_giro),
		CONNECT_ONE_SHOT
	)

func _on_giro_terminado(numero_casillas_giro:int) -> void:
	
	# Ajustas conexiones lógicas aquí
	for casilla_nucleo in entrada_salida.keys():
		var casilla_tablero: Casilla = entrada_salida[casilla_nucleo]
		if casilla_tablero == null:
			continue

		var idx := tablero_conectado.casillas_internas.find(casilla_tablero)
		var nuevo_idx := (idx + numero_casillas_giro) % tablero_conectado.casillas_internas.size()
		entrada_salida[casilla_nucleo] = tablero_conectado.casillas_internas[nuevo_idx]

	girando.emit(false)
