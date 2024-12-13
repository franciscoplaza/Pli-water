extends Node2D

@onready var camera = $Player/Camera2D
@onready var pause_menu =$HUD/Pause_menu
@onready var death_menu = $HUD/Death_menu
var paused = false

func _ready() -> void:
	pause_menu.hide()
	var player = $Player
	var hud = $HUD
	if player and hud:
		if not player.is_connected("life_updated", Callable(hud, "update_life")):
			player.connect("life_updated", Callable(hud, "update_life"))
	else:
		print("Player or HUD not found! Check scene setup.")

	# Conectar la señal de distancia máxima actualizada desde el nodo Chain
	var chain_node = $Player.get_node("Chain")  # Acceder al nodo Chain desde el Player
	chain_node.connect("max_distance_updated", Callable($HUD, "update_max_distance"))
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused: 
		pause_menu.hide()
		Engine.time_scale = 1
		camera.resume_camera()
	else:
		pause_menu.show()
		Engine.time_scale = 0
		camera.pause_camera()
	paused = !paused
