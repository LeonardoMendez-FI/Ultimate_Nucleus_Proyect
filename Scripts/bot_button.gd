extends CheckButton

@onready var controlled_player:Jugador = get_parent()

func _ready() -> void:
	toggled.connect(_on_toggled)

func _on_pressed() -> void:
	if controlled_player: print(controlled_player.color)
	else: print("none")
	controlled_player.state_machine._change_to("Player_State_Inactive")


func _on_toggled(toggled_on: bool) -> void:
	if controlled_player: 
		print(controlled_player.color)
		if toggled_on:
			controlled_player.state_machine._change_to("Player_State_Inactive")
		else:
			controlled_player.state_machine._change_to("Player_State_Inactive")
			
	else: print("none")
	
