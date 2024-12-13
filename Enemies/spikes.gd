extends Area2D

# Conexión inicial
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

# Lógica para manejar el daño al jugador
func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):  # Verifica si el cuerpo tiene el método `take_damage`
		body.take_damage(1)  # Causa 1 punto de daño al jugador
