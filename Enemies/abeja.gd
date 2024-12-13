extends CharacterBody2D

@export var Speed: float = 125.0 # Velocidad de movimiento de la abeja
@export var PlayerPath: NodePath # Ruta al nodo del jugador
@export var VisionRange: float = 325.0 # Rango de visión de la abeja
@export var AttackRange: float = 150.0 # Rango para activar la animación de ataque

var player: Node2D = null
var sprite: AnimatedSprite2D = null
var is_dead: bool = false # Indica si la abeja está "muerta"
var gravity: float = 300.0 # Fuerza de gravedad

func _ready():
	# Obtiene el nodo del jugador usando la ruta especificada
	if PlayerPath != null:
		player = get_node_or_null(PlayerPath)
	else:
		push_error("PlayerPath no está asignado.")
	
	sprite = $AnimatedSprite2D if $AnimatedSprite2D else null

	if sprite != null:
		sprite.play("volar") # Comienza con la animación de volar



func _physics_process(delta):
	if is_dead:
		# Si la abeja está "muerta", aplica la gravedad
		velocity.y += gravity * delta
		
		move_and_slide()
		sprite.flip_v = true
		
		await get_tree().create_timer(2.0).timeout
		queue_free()
		return

	if player != null:
		# Calcula la distancia entre la abeja y el jugador
		var distance_to_player = global_position.distance_to(player.global_position)

		# Cambia la animación según la distancia al jugador
		if distance_to_player <= AttackRange:
			_change_animation("atacar")
		else:
			_change_animation("volar")

		# Si el jugador está dentro del rango de visión
		if distance_to_player <= VisionRange:
			# Calcula la dirección hacia el jugador
			var direction = (player.global_position - global_position).normalized()

			# Aplica el movimiento en la dirección del jugador
			velocity = direction * Speed

			# Gira el sprite hacia la dirección del movimiento
			if direction.x < 0: # Si se mueve a la izquierda
				sprite.flip_h = false
			elif direction.x > 0: # Si se mueve a la derecha
				sprite.flip_h = true
		else:
			# Si el jugador no está dentro del rango de visión, detiene la abeja
			velocity = Vector2.ZERO

	# Mueve la abeja teniendo en cuenta las colisiones
	move_and_slide()

# Cambia la animación del sprite solo si no está ya reproduciéndose
func _change_animation(animation_name: String):
	if sprite != null and sprite.animation != animation_name:
		sprite.play(animation_name)

func _die():
	is_dead = true
	velocity = Vector2.ZERO # Detiene el movimiento
	if sprite != null:
		sprite.play("morir")
	# Opcional: Desactivar el área de colisión para evitar múltiples activaciones
	set_deferred("monitoring", false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):  # Verifica si el cuerpo tiene el método `take_damage`
		body.take_damage(1)  # Causa 1 punto de daño al jugador
	if is_dead:
		return # Ignora las colisiones si la abeja ya está "muerta"

	# Verifica si el cuerpo que tocó pertenece al nodo del jugador
	if body == player:
		_check_animation_frame()
	
# Funcion para que la abeja te mate solamente si tiene el agijón sacado (frames 7 y 7 o solo frame 6)
# Eliminar si queremos que sea en cualquier frame de la animación y en la línea 88 llamar a _die() directamente
func _check_animation_frame() -> void:
	if sprite.frame == 6 or sprite.frame == 7:
		_die()
	else:
		# Espera 0.01 segundos antes de comprobar nuevamente
		get_tree().create_timer(0.01).timeout.connect(_check_animation_frame)
