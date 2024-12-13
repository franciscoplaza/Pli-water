extends Control  

# Variables para guardar la configuración
@export var volume_bus: String = "Master"  # Ajusta al nombre del bus de audio que usas

func _ready():
	# Carga el volumen inicial desde los ajustes guardados
	var saved_volume = ProjectSettings.get_setting("audio/volume/" + volume_bus, 1.0)
	$HSlider.value = saved_volume * 100  # Ajusta según tu rango (0-100)
	set_bus_volume(saved_volume)

func _on_h_slider_value_changed(value: float):
	# Convierte el valor del slider a un rango de 0.0 a 1.0
	var normalized_volume = value / 100.0
	set_bus_volume(normalized_volume)
	save_volume_setting(normalized_volume)

func set_bus_volume(volume: float):
	# Cambia el volumen del bus de audio
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(volume_bus),
		linear_to_db(volume)
	)

func save_volume_setting(volume: float):
	# Guarda el ajuste de volumen en las configuraciones
	ProjectSettings.set_setting("audio/volume/" + volume_bus, volume)
	ProjectSettings.save()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Options.tscn")
