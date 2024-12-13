"""
This script controls the player character with only the hook functionality.
"""
extends CharacterBody2D
class_name Player

const MAX_SPEED: float = 400
const CHAIN_PULL_BASE: float = 20  # Valor base mínimo para el pull
const CHAIN_PULL_MAX: float = 80  # Valor máximo para el pull
const DISTANCE_MIN: float = 400  # Distancia mínima
const DISTANCE_MAX: float = 1800  # Distancia máxima
const AIR_FRICTION_X: float = 0.80
const AIR_FRICTION_Y: float = 1.0

@onready var Damage = $AudioStreamPlayer
@onready var FlyDead = $AudioStreamPlayer2
var chain_velocity: Vector2 = Vector2.ZERO
var current_life: int = 5
var max_life: int = 5
var chain_pull: float = CHAIN_PULL_BASE

@onready var arduino_distance = $ArduinoDistance  # Ruta ajustada para la nueva jerarquía

# Señales
signal life_updated(current_life, max_life)

func _ready() -> void:
	# Intentar encontrar el nodo HUD
	var hud_node = get_node_or_null("../HUD")  # Ajusta esta ruta según tu jerarquía
	if hud_node:
		connect("life_updated", Callable(hud_node, "update_life"))
	emit_signal("life_updated", current_life, max_life)

# Mapeo de distancia a velocidad de pull
func update_chain_pull():
	if arduino_distance:
		var distance = clamp(arduino_distance.Distancia, DISTANCE_MIN, DISTANCE_MAX)
		chain_pull = CHAIN_PULL_BASE + (CHAIN_PULL_MAX - CHAIN_PULL_BASE) * ((distance - DISTANCE_MIN) / (DISTANCE_MAX - DISTANCE_MIN))
		#print(chain_pull)

# Manejo de entrada
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			$Chain.shoot(event.position - get_viewport().get_visible_rect().size * 0.5)
		else:
			$Chain.release()

# Proceso físico del jugador
func _physics_process(_delta: float) -> void:
	update_chain_pull()  # Actualizar la velocidad del pull según la distancia
	velocity.y += 20  # Aplicar gravedad
	move_and_slide()

	if $Chain.hooked:
		chain_velocity = to_local($Chain.tip).normalized() * chain_pull
		if chain_velocity.y > 0:
			chain_velocity.y *= 0.55
		else:
			chain_velocity.y *= 1.40
	else:
		chain_velocity = Vector2.ZERO
	velocity += chain_velocity

	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	if !$Chain.hooked:
		velocity.x *= AIR_FRICTION_X
		velocity.y *= AIR_FRICTION_Y

# Función para manejar el daño
func take_damage(amount: int) -> void:
	current_life -= amount
	current_life = clamp(current_life, 0, max_life)
	emit_signal("life_updated", current_life, max_life)
	Damage.play()
	if current_life == 0:
		die()

# Función para curar al jugador
func heal(amount: int) -> void:
	FlyDead.play()
	current_life += amount
	current_life = clamp(current_life, 0, max_life)
	emit_signal("life_updated", current_life, max_life)

# Función para manejar la muerte del jugador
func die() -> void:
	print("Player has died!")
	# Llama al HUD para mostrar el menú de muerte
	var hud_node = get_node_or_null("../HUD")
	if hud_node:
		hud_node.show_death_menu()
