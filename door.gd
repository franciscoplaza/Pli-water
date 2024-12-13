extends Area2D

@export var target_level_path: String = ""  # Ruta al nivel objetivo

func _ready() -> void:
	pass

func _on_body_entered(body: Node) -> void:
	get_tree().change_scene_to_file(target_level_path)  # Cambiar de escena
