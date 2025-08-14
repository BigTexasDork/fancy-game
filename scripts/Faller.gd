extends Area2D
class_name Faller
## Base class for any falling thing (enemy or pickup). Shows current HP.

@export var color: Color = Color(1, 1, 1, 1)
@export var fall_speed: float = 200.0
@export var hp_range: Vector2i = Vector2i(1, 1) # inclusive
@export var value_min_max: Vector2i = Vector2i(-10, 10) # optional score-ish payload

var hp: int
var value: int
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _viewport_size: Vector2
var _is_dead: bool = false
@onready var hp_label: Label

signal reached_bottom
signal destroyed(value: int)
signal popped(node) # emitted when HP hits 0 (before free)

func _ready() -> void:
	_rng.randomize()
	_viewport_size = get_viewport().get_visible_rect().size
	hp = int(clamp(_rng.randi_range(hp_range.x, hp_range.y), 1, 9999))
	value = _rng.randi_range(value_min_max.x, value_min_max.y)

	if has_node("Polygon2D"):
		var poly: Polygon2D = $Polygon2D
		poly.color = color

	# Centered HP label (assumes ~60x60 body)
	hp_label = Label.new()
	hp_label.name = "HpLabel"
	hp_label.custom_minimum_size = Vector2(60, 60)
	hp_label.position = Vector2(-30, -30)
	hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hp_label.add_theme_font_size_override("font_size", 28)
	hp_label.z_index = 100
	add_child(hp_label)
	_update_hp_label()

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	if position.y > _viewport_size.y + 80.0:
		emit_signal("reached_bottom")
		queue_free()

func hit(projectile: Node) -> void:
	if _is_dead:
		return
	hp -= 1
	_update_hp_label()
	if hp > 0:
		_flash()
		return
	_die() # 0 HP

func fire() -> void:
	# Stub: for future abilities on enemies.
	pass

func _die() -> void:
	_is_dead = true
	set_process(false)
	monitoring = false
	if has_node("CollisionShape2D"):
		var col: CollisionShape2D = $CollisionShape2D
		col.disabled = true

	emit_signal("destroyed", value)
	emit_signal("popped", self)

	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", scale * 1.2, 0.06).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	if is_instance_valid(hp_label):
		tween.parallel().tween_property(hp_label, "modulate:a", 0.0, 0.12)
	tween.tween_callback(queue_free)

func _flash() -> void:
	if not has_node("Polygon2D"):
		return
	var poly: Polygon2D = $Polygon2D
	var from_col: Color = poly.color
	var tween: Tween = create_tween()
	tween.tween_property(poly, "color", Color(1, 1, 1, 1), 0.05)
	tween.tween_property(poly, "color", from_col, 0.12)

func _update_hp_label() -> void:
	if hp_label:
		hp_label.text = str(hp)
