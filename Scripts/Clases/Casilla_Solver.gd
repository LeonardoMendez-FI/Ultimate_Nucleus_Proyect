extends Node
class_name CasillaSolver

var tablero:Tablero = null
var nucleus:Nucleus = null

func caer_in_casilla(dado:Dado_Estandar, ficha_selected:FichaEstandar, casila_selected:Casilla):

	capturar_casilla(ficha_selected)
	
	if casila_selected == ficha_selected.propietario.casilla_salida:
		completar_carrera(ficha_selected)
		
	else:
		match(casila_selected.habilidad):
			GameConstants.HABILIDADES_CASILLA.ESTANDAR:
				pass
			GameConstants.HABILIDADES_CASILLA.DOBLE:
				dado.lanzar()
				await dado.animable.animacion_terminada
			GameConstants.HABILIDADES_CASILLA.GIRO_NUCLEO:
				nucleus.girar(dado.valor)
				await nucleus.animable.animacion_terminada
			GameConstants.HABILIDADES_CASILLA.PROTECCION:
				pass
			_:
				ficha_selected.propietario.puntaje += 1
		
func capturar_casilla(ficha_selected:FichaEstandar) -> void:
	
	for ficha:FichaEstandar in ficha_selected.casilla_actual.fichas.slice(0, -1):
		if ficha.propietario == ficha_selected.propietario:
			regresar_ficha_base(ficha)
		else:
			ficha.capturada = true

func completar_carrera(ficha_selected:FichaEstandar) -> void:
	ficha_selected.propietario.puntaje += ficha_selected.propietario.casilla_salida.fichas.size() + 1
	
	for ficha in ficha_selected.propietario.casilla_salida.fichas.duplicate():
		regresar_ficha_base(ficha)
		
func regresar_ficha_base(ficha:FichaEstandar) -> void:
	ficha.regresar_a_base()
	ficha.reparent(tablero)
	await ficha.animable.animacion_terminada
	
func agregar_ficha(ficha:FichaEstandar, casilla:Casilla) -> void:
	casilla.fichas.append(ficha)
	ficha.z_index += casilla.fichas.size() + 2
	ficha.casilla_actual = casilla

func eliminar_ficha(ficha:FichaEstandar, casilla:Casilla) -> void:
	casilla.fichas.erase(ficha)
