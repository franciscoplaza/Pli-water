extends AudioStreamPlayer

func _ready() -> void:
	if not playing:  # Si no está reproduciendo, iniciar la música
		play()

func _process(_delta: float) -> void:
	if not playing:  # Verificar si la música ha terminado
		play()  # Reiniciar la música

func toggle_music() -> void:
	if playing:
		stop()
	else:
		play()
