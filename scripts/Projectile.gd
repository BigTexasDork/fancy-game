extends Area2D
class_name Projectile

@export var speed: float = 700.0

var _viewport_size: Vector2

func _ready() -> void:
	_viewport_size = get_viewport().get_visible_rect().size

func _process(delta: float) -> void:
	position.y -= speed * delta
	if position.y < -80.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Faller:
		(area as Faller).hit(self)
		queue_free()
