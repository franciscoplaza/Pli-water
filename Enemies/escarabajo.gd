extends CharacterBody2D

@export var Speed: float = 125.0 # Velocidad de movimiento del Escarabajo
@export var Gravity: float = 500.0 # Fuerza de gravedad
@export var MaxFallSpeed: float = 300.0 # Velocidad máxima de caída
@export var PlayerPath: NodePath # Ruta al nodo del jugador
@export var VisionRange: float = 300.0 # Rango de visión del escarabajo

var player: Node2D = null
var sprite: AnimatedSprite2D = null # Referencia al Sprite del Escarabajo

func _ready():
	# Obtiene el nodo del jugador usando la ruta especificada
	if PlayerPath != null:
		player = get_node_or_null(PlayerPath)
	else:
		push_error("PlayerPath no está asignado.")

	sprite = $AnimatedSprite2D if $AnimatedSprite2D else null

	if sprite != null:
		sprite.play("Caminar") # Comienza con la animación de caminar

func _physics_process(delta):
	# Aplica la gravedad
	velocity.y += Gravity * delta

	# Limita la velocidad máxima de caída
	if velocity.y > MaxFallSpeed:
		velocity.y = MaxFallSpeed

	# Si existe el jugador, calcula la distancia
	if player != null:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player <= VisionRange:
			# Si el jugador está en rango, ajusta la dirección y persigue
			var direction = (player.global_position - global_position).normalized()
			velocity.x = direction.x * Speed

			# Gira el sprite solo si se mueve a la izquierda o derecha
			if sprite != null:
				if velocity.x < 0: # Si se mueve a la izquierda
					sprite.flip_h = false
				elif velocity.x > 0: # Si se mueve a la derecha
					sprite.flip_h = true

		else:
			# Si el jugador no está en rango, el escarabajo se detiene
			velocity.x = 0

	# Mueve el escarabajo teniendo en cuenta colisiones
	move_and_slide()
