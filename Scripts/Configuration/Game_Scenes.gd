extends Node
class_name Game_Scenes

# JUEGO
const scene_juego : PackedScene = preload("res://Scenes/Game.tscn")
const scene_fondo : PackedScene = preload("res://Scenes/Fondo.tscn")

# COMPONENTES
# Jugador
const scene_jugador : PackedScene = preload("res://Scenes/jugador.tscn")
const scene_ficha : PackedScene = preload("res://Scenes/Ficha.tscn")

# Tablero
const scene_tablero_bakery : PackedScene = preload("res://Scenes/Bakery/tablero_bakery.tscn")
const scene_nucleus : PackedScene = preload("res://Scenes/Nucleus.tscn")
const scene_casilla : PackedScene = preload("res://Scenes/Casilla.tscn")
