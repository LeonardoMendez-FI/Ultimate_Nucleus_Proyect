extends Node2D
class_name PoolJugadores

@export var bot:Dictionary[String, PackedScene] = {"Facil":null, "Medio":null, "Dificil":null}
@export var jugador:PackedScene

var jugadores:Array

func configurar() -> void :
	for index in range(GameConfiguration.numero_jugadores_activos):
		var nuevo_jugador
		if index < GameConfiguration.numero_de_bots:
			nuevo_jugador = bot[GameConfiguration.dificultad_bots].instantiate()
		else:
			nuevo_jugador = jugador.instantiate()
		
		jugadores.append(nuevo_jugador)
		add_child(nuevo_jugador)
		
		
