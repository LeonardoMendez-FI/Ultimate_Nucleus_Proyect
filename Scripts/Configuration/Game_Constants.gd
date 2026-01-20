extends Node
class_name NodeGameConstants

const NUCLEUS_RADIUS = 220
const INT_RADIUS = 295
const EXT_RADIUS = 380
	
# Colores
const COLORS = {
	WHITE = Color(255.0, 255.0, 255.0, 1.0),
	BLACK = Color(0.0, 0.0, 0.0, 1.0),
	RED = Color(0.571, 0.0, 0.169, 1.0),
	GREEN = Color(0.0, 0.404, 0.015, 1.0),
	BLUE = Color(0.074, 0.0, 0.46, 1.0),
	PURPLE = Color(0.385, 0.025, 0.457, 1.0),
	GRAY = Color(0.693, 0.502, 0.428, 1.0)
}

enum NUCLEUS_SHAPES{Triangle, Square, Hexagon, Dodecagon, Octadecagon, Circle}

const SHAPES_DICT = {
		NUCLEUS_SHAPES.Triangle: {Name = "Triangulo", Entrances_Number = 3, Side_Tiles_Number = 9},
		NUCLEUS_SHAPES.Square: {Name = "Cuadrado", Entrances_Number = 4, Side_Tiles_Number  =  7},
		NUCLEUS_SHAPES.Hexagon: {Name = "Hexagono", Entrances_Number = 6, Side_Tiles_Number = 5},
		NUCLEUS_SHAPES.Dodecagon: {Name = "Dodecagono", Entrances_Number = 12, Side_Tiles_Number = 3},
		NUCLEUS_SHAPES.Octadecagon: {Name = "Octadecagono", Entrances_Number = 18, Side_Tiles_Number = 3},
		NUCLEUS_SHAPES.Circle: {Name = "Circulo", Entrances_Number = 36, Side_Tiles_Number = 2}
	}

enum TILE_HABILITY{STANDARD, DOUBLE, PROTECTION, NUCLEUS_SPIN, SPAWN}

const STR_TILE_HABILITY:= {
		TILE_HABILITY.STANDARD: "Estandar", 
		TILE_HABILITY.DOUBLE: "Turno Doble", 
		TILE_HABILITY.PROTECTION: "Proteccion", 
		TILE_HABILITY.NUCLEUS_SPIN: "Girar Nucleus",
		TILE_HABILITY.SPAWN: "Casilla Meta"
	}

enum TILE_TYPES{BASE, BOARD, NUCLEUS}

const STR_TILE_TYPES:= {
		TILE_TYPES.BASE: "Base", 
		TILE_TYPES.BOARD: "Board", 
		TILE_TYPES.NUCLEUS: "Nucleus"
	}

enum PLAYERS_TEAM{RED, BLUE, GREEN, PURPLE, ALL}

const STR_PLAYERS_TEAM = {
		PLAYERS_TEAM.RED:  "Rojo", 
		PLAYERS_TEAM.BLUE: "Azul", 
		PLAYERS_TEAM.GREEN: "Verde", 
		PLAYERS_TEAM.PURPLE: "Morado", 
		PLAYERS_TEAM.ALL: "All"
	}

const GAME_STATES = {
	StartGame = "GameState_StartGame",
	NewTurn = "GameState_NewTurn",
	RoolOrDeploy = "GameState_TRoolOrDeploy",
	RolledDice = "GameState_RolledDice",
	SelectedDie = "GameState_SelectedDie",
	SelectedToken = "GameState_SelectedToken",
	LastAction = "GameState_LastAction",
	DeployedToken = "GameState_DeployedToken"
}

const PLAYER_STATES = {
	ACTIVE_PLAYER = "PlayerState_Active",
	INACTIVE_PLAYER = "PlayerState_Inactive",
	BOT_PLAYER = "PlayerState_Bot"
}

enum BOTS_DIFICULT{EASY, MEDIUM, HARD}

const STR_BOTS_DIFICULT = {
	BOTS_DIFICULT.EASY : "Facil",
	BOTS_DIFICULT.MEDIUM : "Medio",
	BOTS_DIFICULT.HARD : "Dificil"
}
