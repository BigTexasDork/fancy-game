extends Node2D
class_name Defender

@export var fire_speed: float = 3.0 # projectiles per second
@export var projectile_scene: PackedScene
@export var multi_shot: int = 1 # 1..3

var _fire_timer: Timer

func _ready() -> void:
	_fire_timer = Timer.new()
	_fire_timer.one_shot = false
	add_child(_fire_timer)
	_fire_timer.timeout.connect(_spawn_projectile)
	_update_fire_timer()

func _update_fire_timer() -> void:
	if fire_speed <= 0.0:
		_fire_timer.stop()
	else:
		_fire_timer.wait_time = 1.0 / fire_speed
		_fire_timer.start()

func set_fire_speed(v: float) -> void:
	fire_speed = v
	_update_fire_timer()

func set_multi_shot(count: int) -> void:
	multi_shot = clampi(count, 1, 3)

func _spawn_projectile() -> void:
	if projectile_scene == null:
		return
	var n := clampi(multi_shot, 1, 3)
	var spacing := 18.0
	var start_x := -spacing * float(n - 1) / 2.0
	for i in range(n):
		var p := projectile_scene.instantiate() as Area2D
		get_tree().current_scene.add_child(p)
		p.global_position = global_position + Vector2(start_x + i * spacing, -22)

func _unhandled_input(event: InputEvent) -> void:
	# Drag to move horizontally (touch or mouse); Y stays fixed at bottom.
	if event is InputEventScreenDrag or event is InputEventScreenTouch or event is InputEventMouseMotion or event is InputEventMouseButton:
		var pos := (event as InputEventMouse).position if event is InputEventMouse else (event as InputEventScreenTouch).position if event is InputEventScreenTouch else (event as InputEventScreenDrag).position if event is InputEventScreenDrag else Vector2.ZERO
		if pos != Vector2.ZERO:
			var w := get_viewport().get_visible_rect().size.x
			position.x = clamp(pos.x, 0.0, w)
