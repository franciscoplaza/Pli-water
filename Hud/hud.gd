extends CanvasLayer

@onready var hearts_container = $HeartsContainer
@onready var distance_bar = $DistanceBar
@onready var death_menu = $Death_menu  # Asegúrate de conectar este nodo
@onready var camera = $"../Player/Camera2D"


var full_heart = preload("res://Assets/hearts_hud.png")
var empty_heart = preload("res://Assets/no_hearts_hud.png")

func _ready() -> void:
	death_menu.hide()



# Actualiza los corazones según la vida actual
func update_life(current_life: int, max_life: int) -> void:
	if hearts_container:
		var hearts = hearts_container.get_children()
		for i in range(hearts.size()):
			if i < current_life:
				hearts[i].texture = full_heart
			else:
				hearts[i].texture = empty_heart
	else:
		print("HeartsContainer no encontrado o vacío.")

# Actualiza la barra de distancia máxima
func update_max_distance(max_distance: float, max_limit: float = 300.0) -> void:
	var progress = clamp((max_distance - max_limit) / (max_limit), 0.0, 1.0)
	distance_bar.value = progress * 100

# Muestra el menú de muerte
func show_death_menu() -> void:
	death_menu.show()
	Engine.time_scale = 1
	camera.pause_camera()

# Oculta el menú de muerte
func hide_death_menu() -> void:
	death_menu.hide()
	Engine.time_scale = 0
	camera.resume_camera()
