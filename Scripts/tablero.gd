extends Sprite2D
class_name Tablero

var casillas_internas : Array[Casilla] = []
var casillas_externas : Array[Casilla] = []

func _ready():
	_reconstruir_casillas()

func _reconstruir_casillas():
	casillas_internas.clear()
	casillas_externas.clear()

	var index = 0
	for node in get_tree().get_nodes_in_group("Casilla Tablero"):
		if node is Casilla:
			casillas_internas.append(node)
			node.index_casilla = index
		index += 1
		
	index = 0		
	for node in get_tree().get_nodes_in_group("Casilla Base"):
		
		if node is Casilla:
			casillas_externas.append(node)
			node.index_casilla = index
		index+= 1
		
			
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
		
	
	
