""" This script controls the chain. """
extends Node2D

@onready var links = $Links
@onready var arduino_distance = $"../ArduinoDistance"  # Ruta ajustada para la nueva jerarquía
@onready var hook_sprite = $Tip/Hook  # Referencia al AnimatedSprite2D

signal max_distance_updated(max_distance)  # Declaración de la señal

var direction: Vector2 = Vector2.ZERO
var tip: Vector2 = Vector2.ZERO
const SPEED: float = 10
const MAX_DISTANCE: float = 300.0
var distance_multiplier: float = 1.0

var flying: bool = false
var hooked: bool = false

func shoot(dir: Vector2) -> void:
	direction = dir.normalized()
	flying = true
	tip = self.global_position
	hook_sprite.play("idle")  # Reproducir animación de vuelo

func release() -> void:
	flying = false
	hooked = false

func _process(_delta: float) -> void:
	self.visible = flying or hooked
	if not self.visible:
		return
	var tip_loc = self.to_local(tip)
	links.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(270)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(270)
	links.position = tip_loc
	links.region_rect.size.y = tip_loc.length()

func _physics_process(_delta: float) -> void:
	$Tip.global_position = tip
	var distance_to_tip = self.global_position.distance_to(tip)
	var max_allowed_distance = MAX_DISTANCE * distance_multiplier
	
	# Obtén la distancia del Arduino
	if arduino_distance:
		distance_multiplier = 1.0 + (2600.0 - arduino_distance.Distancia) / 2200.0
		#print(distance_multiplier)
		emit_signal("max_distance_updated", max_allowed_distance)  # Emitir señal con distancia máxima
	if flying:
		if distance_to_tip >= max_allowed_distance:
			flying = false
			return
		if $Tip.move_and_collide(direction * SPEED):
			hooked = true
			flying = false
			hook_sprite.play("hooked")  # Reproducir animación de gancho enganchado
	tip = $Tip.global_position
