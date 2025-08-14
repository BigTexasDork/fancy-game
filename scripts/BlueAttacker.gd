extends Faller
class_name BlueAttacker

func _ready() -> void:
	color = Color(0.2, 0.6, 0.95, 1)
	fall_speed = 300.0
	hp_range = Vector2i(1, 1)
	super._ready()
