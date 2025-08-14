extends Area2D
class_name Attacker
## Base class for all attackers.

@export var color: Color = Color(1, 1, 1, 1)
@export var fall_speed: float = 200.0
@export var hp_range: Vector2i = Vector2i(1, 1) # inclusive
@export var value_min_max: Vector2i = Vector2i(-10, 10)

var hp: int
var value: int
var _rng := RandomNumberGenerator.new()
var _viewport_size: Vector2
var _is_dead := false

signal reached_bottom
signal destroyed(value: int)

func _ready() -> void:
	_rng.randomize()
	_viewport_size = get_viewport().get_visible_rect().size
	# randomize stats derived from exports
	hp = clampi(_rng.randi_range(hp_range.x, hp_range.y), 1, 9999)
	value = _rng.randi_range(value_min_max.x, value_min_max.y)
	# apply visuals
	if has_node("Polygon2D"):
		$Polygon2D.color = color

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	if position.y > _viewport_size.y + 80.0:
		emit_signal("reached_bottom")
		queue_free()

func hit(projectile: Node) -> void:
	# Default 1-damage hit; subclasses can override if needed.
	if _is_dead:
		return
	hp -= 1
	if hp > 0:
		_flash()
		return

	_is_dead = true
	set_process(false)
	monitoring = false
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true

	emit_signal("destroyed", value)

	var tween := create_tween()
	tween.tween_property(self, "scale", scale * 1.2, 0.06).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)

func _flash() -> void:
	if not has_node("Polygon2D"):
		return
	var tween := create_tween()
	var poly := $Polygon2D
	var from_col := poly.color
	tween.tween_property(poly, "color", Color(1,1,1,1), 0.05)
	tween.tween_property(poly, "color", from_col, 0.12)

func fire() -> void:
	# Stub: for future attacker abilities.
	pass
