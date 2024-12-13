extends Control


func _on_volume_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Volume.tscn")

func _on_fullscreen_pressed() -> void:
	 # Alterna el modo de pantalla completa
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	set_fullscreen_mode(not is_fullscreen)

func set_fullscreen_mode(fullscreen: bool):
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
