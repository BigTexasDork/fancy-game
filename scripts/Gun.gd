extends Faller
class_name Gun
## Pickup. When popped, the defender gains multi-shot = barrel_count.

@export var barrel_count: int = 0 # if 0, randomize 1..3 in _ready

func _ready() -> void:
	color = Color(0.3, 0.9, 0.45, 1)
	fall_speed = 240.0
	hp_range = Vector2i(1, 2)
	super._ready()
	if barrel_count <= 0:
		barrel_count = _rng.randi_range(1, 3)
	barrel_count = clampi(barrel_count, 1, 3)
	# Show barrel_count on the label instead of HP? Keep HP visible for consistency.
	# If you'd rather show the bonus value, uncomment:
	# if hp_label: hp_label.text = str(barrel_count)
