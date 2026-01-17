extends Sprite2D
class_name Tablero

var ruta_sprite = "res://Resources/Sprites/Casilla/FondoCasillaRoja.png"
var casillas_internas : Array[Casilla] = []
var casillas_externas : Array[Casilla] = []
@export var escena: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crear_tablero()

func crear_tablero() -> void:
	
	var angulo : float

	for indice in range(36):
		angulo = deg_to_rad(indice * 10 - 5)
			
		var pos_int = obtener_position(Game_Constants.RADIO_INT, angulo)
		var pos_ext = obtener_position(Game_Constants.RADIO_EXT, angulo)
		
		casillas_internas.append(_crear_casilla({"posicion":pos_int, "index":indice, 
		"tipo":GameConstants.TIPO_CASILLA.TABLERO, "angulo":-angulo}, true))
		
		casillas_externas.append(_crear_casilla({"posicion":pos_ext, "index":indice, 
		"tipo":GameConstants.TIPO_CASILLA.BASE, "angulo":-angulo}, false))

func obtener_position(radio:float, angulo:float) -> Vector2:
	var pos: = Vector2(position.x + radio*cos(angulo),
			-(position.y + radio*sin(angulo)))
	return pos
	
func _crear_casilla(args:={}, vision:bool = true) -> Casilla:
	var nueva_casilla:Casilla = escena.instantiate()
	nueva_casilla.visible = vision
	nueva_casilla.configurar(args)
	add_child(nueva_casilla)
	
	return nueva_casilla

func obtener_bases_jugador(base_index:int = 0) -> Array[Casilla]:
	var bases:Array[Casilla] = []
	for i in range(GameConfiguration.numero_fichas_jugador):
		var nueva_base:Casilla = casillas_externas[(base_index+i-2)%casillas_externas.size()]
		nueva_base.visible = true
		bases.append(nueva_base)
	return bases

func obtener_salida_jugador(base_index:int = 0) -> Casilla:
	var salida_jugador:Casilla = casillas_internas[base_index]
	salida_jugador.visible = true
	return salida_jugador
		
	
	
