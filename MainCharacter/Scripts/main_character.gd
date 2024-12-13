extends Node2D

func _ready() -> void:
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
	
	# Simular daño al jugador (puedes comentar o eliminar esta línea si no es necesaria)
	# $Player.take_damage(1)
