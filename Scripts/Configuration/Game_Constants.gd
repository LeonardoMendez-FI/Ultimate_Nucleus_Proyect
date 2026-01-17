extends Node
class_name Game_Constants

const NUCLEUS_RADIUS = 220
const RADIO_INT = 295
const RADIO_EXT = 380
	
# Colores
const COLORES = {
	WHITE = Color(255.0, 255.0, 255.0, 1.0),
	BLACK = Color(0.0, 0.0, 0.0, 1.0),
	RED = Color(0.571, 0.0, 0.169, 1.0),
	GREEN = Color(0.0, 0.404, 0.015, 1.0),
	BLUE = Color(0.074, 0.0, 0.46, 1.0),
	PURPLE = Color(0.385, 0.025, 0.457, 1.0),
	GRAY = Color(0.693, 0.502, 0.428, 1.0)
}

const FIGURAS = {
		Triangulo = {"Numero_de_entradas": 3, "Numero_Casillas_Lado": 9},
		Cuadrtado = {"Numero_de_entradas": 4, "Numero_Casillas_Lado": 7},
		Hexagono = {"Numero_de_entradas": 6, "Numero_Casillas_Lado": 5},
		Dodecagono = {"Numero_de_entradas": 12, "Numero_Casillas_Lado":3},
		Bifordecagono = {"Numero_de_entradas": 24, "Numero_Casillas_Lado":2},
		Trisidecagono = {"Numero_de_entradas": 36, "Numero_Casillas_Lado":2}
	}

const HABILIDADES_CASILLA = {
		ESTANDAR = "Estandar", 
		DOBLE = "Doble", 
		PROTECCION = "Proteccion", 
		GIRO_NUCLEO = "Giro_Nucleo",
		SALIDA = "Salida"
	}

const TIPO_CASILLA = {
		BASE = "Base", 
		TABLERO = "Tablero", 
		NUCLEUS = "Nucleus"
	}

const COLORES_PLAYER = {
		ROJO = "Rojo", 
		AZUL = "Azul", 
		VERDE = "Verde", 
		MORADO = "Morado", 
		ALL = "All"
	}

const GAME_STATES = {
	Inicio = "State_Inicio",
	Nuevo_Turno = "State_Iniciar_Turno",
	Tirar_Sacar = "State_Tirar_Sacar",
	Dados_Tirados = "State_Dados_Tirados",
	Dado_Seleccionado = "State_Dado_Seleccionado",
	Ficha_Seleccionada = "State_Ficha_Seleccionada",
	Ultima_Accion = "State_Ultima_Accion",
	Ficha_Sacada = "State_Ficha_Sacada"
}
