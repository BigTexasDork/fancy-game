extends Area2D
class_name Attacker

@export var speed: float = 220.0
var value: int

var _rng := RandomNumberGenerator.new()
var _viewport_size: Vector2

signal reached_bottom

func _ready() -> void:
	_rng.randomize()
	value = _rng.randi_range(-10, 10)
	_viewport_size = get_viewport().get_visible_rect().size

func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > _viewport_size.y + 80.0:
		emit_signal("reached_bottom")
		queue_free()

func hit(projectile: Node) -> void:
	# Stub for now: called when a projectile overlaps this attacker
	pass

func fire() -> void:
	# Stub: future attackers might shoot back
	pass
