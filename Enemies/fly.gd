extends Area2D

@export var LifeRecovery: int = 1  # Cantidad de vida que el jugador recupera al matar la mosca
@export var DamageToPlayer: int = 1  # Daño que la mosca hace al jugador
var sprite: AnimatedSprite2D = null
signal fly_killed  # Señal emitida cuando la mosca muere

func _ready() -> void:
	sprite = $AnimatedSprite2D if $AnimatedSprite2D else null
	if sprite != null:
		sprite.play("Idle")  # Comienza con la animación de volar

	# Conectar el método al evento de colisión si no está conectado
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

# Maneja interacciones con el jugador o el hook
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):  # Si el jugador choca con la mosca
		body.take_damage(DamageToPlayer)
	elif body.name == "Tip":  # Si el hook golpea a la mosca (verifica el nodo Tip del Chain)
		emit_signal("fly_killed")
		var player = body.get_parent().get_parent()  # Obtener el jugador a través de los nodos padre
		if player and player.has_method("heal"):  # Asegurarse de que el nodo sea el jugador
			player.heal(LifeRecovery)
		queue_free()  # Destruir la mosca
