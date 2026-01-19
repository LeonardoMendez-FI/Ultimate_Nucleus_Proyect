# Nucleus_Bakery.gd - SÓLO para generar
extends Node
class_name NucleusBakery

var generando := false
var nuevo_nucleus:Nucleus
const scene_casilla = preload(GameScenes.scene_casilla)

@export var guardar:bool = false:
	set(value):
		if value:
			guardar_como_escena()
		guardar = false

@export var figura: = GameConstants.FIGURAS.Triangulo:
	set(value):
		figura = value
		numero_entradas = GameConstants.DIC_FIGURAS[figura].Numero_Entradas
		numero_casillas_lado = GameConstants.DIC_FIGURAS[figura].Numero_Casillas_Lado
		
		if nuevo_nucleus and is_instance_valid(nuevo_nucleus):
			nuevo_nucleus.queue_free()
		
		generar()
		
var numero_entradas : int
var numero_casillas_lado : int 

func _ready():
	# Este script SÓLO genera y guarda
	generar()


func generar():
	if generando:
		return
	generando = true
	# Crear tablero correctamente
	nuevo_nucleus = Nucleus.new()
	add_child(nuevo_nucleus)
	
	nuevo_nucleus.numero_entradas = numero_entradas
	var anim = Animable.new()
	nuevo_nucleus.animable = anim
	nuevo_nucleus.add_child(anim)
	anim.owner = nuevo_nucleus

	# CLAVE: owner para que se pueda guardar
	nuevo_nucleus.owner = self

	call_deferred("_crear_nucleo")	
	call_deferred("_fin_generar")

func _fin_generar():
	generando = false

func _crear_nucleo() -> void:

	var vertices: Array[Vector2] = []

	for i in range(numero_entradas):
		var angulo := deg_to_rad(-i * (360.0 / numero_entradas) + 5)
		vertices.append(
			nuevo_nucleus.global_position +
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
				nueva_casilla.add_to_group("Nucleus Vertice", true)

			casilla_idx += 1
			
func _crear_casilla(args:={}) -> Casilla:

	var nueva_casilla:Casilla = scene_casilla.instantiate()
	nueva_casilla.configurar(args)
	nuevo_nucleus.add_child(nueva_casilla)
	nueva_casilla.owner = nuevo_nucleus
	nueva_casilla.name = "Casilla_Nucleus_%02d" % [args["index"]]
	nueva_casilla.add_to_group("Casilla Nucleus", true)
	
	return nueva_casilla
	
func guardar_como_escena():
	var escena = PackedScene.new()
	escena.pack(nuevo_nucleus)
	ResourceSaver.save(escena, GameScenes.scene_nucleus%[GameConstants.DIC_FIGURAS[figura].Nombre])
	print("✅ Guardado!")
