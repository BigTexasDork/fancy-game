extends Attacker
class_name BlueAttacker

func _ready() -> void:
	color = Color(0.2, 0.6, 0.95, 1)    # blue
	fall_speed = 300.0
	hp_range = Vector2i(1, 1)           # always 1 HP
	super._ready()
