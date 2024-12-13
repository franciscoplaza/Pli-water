"""
This script controls the dynamic camera.
"""
extends Camera2D

# Radius of the zone in the middle of the screen where the cam doesn't move
const DEAD_ZONE = 80
var paused = false

func _input(event: InputEvent) -> void:
	if not paused:
		if event is InputEventMouseMotion:  # Si el mouse se mueve...
			var _target = get_local_mouse_position()  # Obtén la posición del mouse en el espacio local de la cámara
			if _target.length() < DEAD_ZONE:  # Si estamos en la zona muerta...
				self.position = Vector2(0, 0)  # ... centrar la cámara
			else:
				# _target.normalized() es la dirección hacia donde moverse
				# _target.length() - DEAD_ZONE es la distancia fuera de la zona muerta
				self.position = _target.normalized() * (_target.length() - DEAD_ZONE) * 0.5

func pause_camera():
	paused = true

func resume_camera():
	paused = false
