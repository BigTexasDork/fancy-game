extends Faller
class_name RedAttacker

func _ready() -> void:
	color = Color(0.85, 0.25, 0.25, 1)
	fall_speed = 220.0
	hp_range = Vector2i(1, 2)
	super._ready()
