extends Control
class_name Jugador

@export var color:= GameConstants.COLORES_PLAYER.ALL
@export var index_base:int = 0

var casilla_salida:Casilla = null

var activo:bool = true

var fichas:Array[FichaEstandar] = []

var puntaje:int = 0

func configurar(bases, salida) -> void:
	casilla_salida = salida
	casilla_salida.color_habilidad = color
	casilla_salida.habilidad = GameConstants.HABILIDADES_CASILLA.SALIDA
	crear_fichas(bases)

func crear_fichas(bases:Array) -> void:
	
	const scene_ficha = preload(GameScenes.scene_ficha)
	for i in range(GameConfiguration.numero_fichas_jugador):
		
		var nueva_ficha:FichaEstandar = scene_ficha.instantiate()
		nueva_ficha.call_deferred("configurar", self, bases[i])
		fichas.append(nueva_ficha)
		
func fichas_in_base() -> Array[FichaEstandar]:
	var fichas_en_base:Array[FichaEstandar] = []
	for ficha in fichas:
		if ficha.is_in_base():
			fichas_en_base.append(ficha)
	return fichas_en_base

func fichas_in_game() -> Array[FichaEstandar]:
	var fichas_en_juego:Array[FichaEstandar] = []
	for ficha in fichas:
		if ficha.is_in_game():
			fichas_en_juego.append(ficha)
	return fichas_en_juego
