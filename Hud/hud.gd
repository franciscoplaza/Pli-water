extends CanvasLayer

@onready var hearts_container = $HeartsContainer
@onready var distance_bar = $DistanceBar
@onready var death_menu = $DeathMenu  # Asegúrate de conectar este nodo
@onready var retry_button = $DeathMenu/RetryButton
@onready var main_menu_button = $DeathMenu/MainMenuButton

var full_heart = preload("res://Assets/hearts_hud.png")
var empty_heart = preload("res://Assets/no_hearts_hud.png")

func _ready() -> void:
	# Conectar botones a las funciones correspondientes usando Callable
	retry_button.connect("pressed", Callable(self, "_on_retry_pressed"))
	main_menu_button.connect("pressed", Callable(self, "_on_main_menu_pressed"))


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
	death_menu.visible = true
	get_tree().paused = true  # Pausar la escena

# Oculta el menú de muerte
func hide_death_menu() -> void:
	death_menu.visible = false
	get_tree().paused = false  # Reanudar la escena

# Función para manejar el botón de reintentar
func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()  # Recarga la escena actual

# Función para manejar el botón de regresar al menú principal
func _on_main_menu_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")  # Cambiar a la escena del menú principal
