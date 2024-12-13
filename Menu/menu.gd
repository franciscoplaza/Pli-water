extends Control



func _on_Play_pressed() -> void:
	get_tree().change_scene_to_file("res://ecenario_1.tscn")


func _on_Options_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Options.tscn")


func _on_Quit_pressed() -> void:
	get_tree().quit()
