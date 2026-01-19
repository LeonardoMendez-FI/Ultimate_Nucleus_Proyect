extends Node
class_name Node_Game_Constants

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

enum FIGURAS{Triangulo, Cuadrado, Hexagono, Dodecagono, Octadecagono, Trisidecagono}

const DIC_FIGURAS = {
		FIGURAS.Triangulo: {Nombre = "Triangulo", Numero_Entradas = 3, Numero_Casillas_Lado = 9},
		FIGURAS.Cuadrado: {Nombre = "Cuadrado", Numero_Entradas = 4, Numero_Casillas_Lado  =  7},
		FIGURAS.Hexagono: {Nombre = "Hexagono", Numero_Entradas = 6, Numero_Casillas_Lado = 5},
		FIGURAS.Dodecagono: {Nombre = "Dodecagono", Numero_Entradas = 12, Numero_Casillas_Lado = 3},
		FIGURAS.Octadecagono: {Nombre = "Octadecagono", Numero_Entradas = 18, Numero_Casillas_Lado = 3},
		FIGURAS.Trisidecagono: {Nombre = "Trisidecagono", Numero_Entradas = 36, Numero_Casillas_Lado = 2}
	}

enum HABILIDADES_CASILLA{ESTANDAR, DOBLE, PROTECCION, GIRO_NUCLEO, SALIDA}

const STR_HABILIDADES:= {
		HABILIDADES_CASILLA.ESTANDAR: "Estandar", 
		HABILIDADES_CASILLA.DOBLE: "Doble", 
		HABILIDADES_CASILLA.PROTECCION: "Proteccion", 
		HABILIDADES_CASILLA.GIRO_NUCLEO: "GiroNucleo",
		HABILIDADES_CASILLA.SALIDA: "Salida"
	}

enum TIPO_CASILLA{BASE, TABLERO, NUCLEUS}

const STR_TIPOS:= {
		TIPO_CASILLA.BASE: "Base", 
		TIPO_CASILLA.TABLERO: "Tablero", 
		TIPO_CASILLA.NUCLEUS: "Nucleus"
	}

enum COLORES_PLAYER{ROJO, AZUL, VERDE, MORADO, ALL}

const STR_COLORES = {
		COLORES_PLAYER.ROJO:  "Rojo", 
		COLORES_PLAYER.AZUL: "Azul", 
		COLORES_PLAYER.VERDE: "Verde", 
		COLORES_PLAYER.MORADO: "Morado", 
		COLORES_PLAYER.ALL: "All"
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

enum DIFICULTAD_BOTS{FACIL, MEDIO, DIFICIL}

const STR_BOTS = {
	DIFICULTAD_BOTS.FACIL : "Facil",
	DIFICULTAD_BOTS.MEDIO : "Medio",
	DIFICULTAD_BOTS.DIFICIL : "Dificil"
}
