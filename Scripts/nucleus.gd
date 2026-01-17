extends Sprite2D
class_name Nucleus

@export var es_autonomo : bool = false
@export var escena : PackedScene
@onready var animable:Animable = $Animable

signal girando(it_is:bool)
var casillas: Array[Casilla] = []
var numero_entradas : int
var numero_casillas_lado : int 

var tablero_conectado:Tablero

# Primero: Casilla núcleo -> índice del tablero
# Después de conectar: Casilla núcleo -> Casilla tablero
var entrada_salida: Dictionary = {}

var vertices_idx: Array[int] = []

func _process(_delta: float) -> void:
	for casilla in casillas:
		casilla.visible = true

func configurar(figura_nucleo:String = GameConfiguration.figura_nucleo) -> void:
	numero_entradas = Game_Constants.FIGURAS[figura_nucleo]["Numero_de_entradas"]
	numero_casillas_lado = Game_Constants.FIGURAS[figura_nucleo]["Numero_Casillas_Lado"]
	
	crear_nucleo()
	
	
func _ready() -> void:
	if es_autonomo:
		configurar()
# -------------------------------------------------
# CREACIÓN DEL NÚCLEO
# -------------------------------------------------
func crear_nucleo() -> void:

	var vertices: Array[Vector2] = []

	for i in range(numero_entradas):
		var angulo := deg_to_rad(-i * (360.0 / numero_entradas) + 5)
		vertices.append(
			global_position +
			Vector2(
				Game_Constants.NUCLEUS_RADIUS * cos(angulo),
				Game_Constants.NUCLEUS_RADIUS * sin(angulo)
			)
		)

	var casilla_idx := 0

	for i in range(numero_entradas):
		var start: Vector2 = vertices[i]
		var end: Vector2 = vertices[(i + 1) % numero_entradas]
		var dir_lado := (end - start).normalized()
		var normal := Vector2(-dir_lado.y, dir_lado.x)
		var angulo_lado := GameResources.visualizer_solver.obtener_rotacion(normal)

		for j in range(numero_casillas_lado - 1):
			var t := float(j) / float(numero_casillas_lado - 1)
			var pos := start.lerp(end, t)
			var nueva_casilla: Casilla 
			var angulo
			if j>0: angulo = angulo_lado 
			else: angulo = GameResources.visualizer_solver.obtener_rotacion(pos)
			
			nueva_casilla = _crear_casilla({"posicion":pos, "index":casilla_idx, 
			"tipo":GameConstants.TIPO_CASILLA.NUCLEUS, "angulo":angulo})

			# Vértice / Entrada-Salida
			if j == 0:
				var entrada_idx := int(round(i * (36.0 / numero_entradas))) % 36
				entrada_salida[nueva_casilla] = entrada_idx
				vertices_idx.append(casilla_idx)

			casilla_idx += 1

func _crear_casilla(args:={}) -> Casilla:
	var nueva_casilla = escena.instantiate()
	nueva_casilla.configurar(args)
	add_child(nueva_casilla)
	casillas.append(nueva_casilla)
	girando.connect(nueva_casilla._on_nucleo_girando)
	return nueva_casilla
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

	#resaltar_vertices(false)
	#resaltar_conexiones_tablero(false)
	
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

	#resaltar_vertices(false)
	#resaltar_conexiones_tablero(false)
	girando.emit(false)

# -------------------------------------------------
# RESALTADO VISUAL
# -------------------------------------------------
func resaltar_vertices(activo: bool) -> void:
	for idx in vertices_idx:
		if idx >= 0 and idx < casillas.size():
			if activo:
				casillas[idx].icon.self_modulate = GameConstants.BLACK
			else:
				casillas[idx].icon.self_modulate = GameConstants.WHITE

func resaltar_conexiones_tablero(activo: bool) -> void:
	for casilla_tablero in entrada_salida.values():
		if casilla_tablero != null:
			if activo:
					casilla_tablero.icon.self_modulate = GameConstants.BLACK
			else:
				casilla_tablero.icon.self_modulate = GameConstants.WHITE
