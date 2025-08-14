extends Node2D

@export var faller_scenes: Array[PackedScene]
@export var defender_scene: PackedScene
@export var spawn_interval: float = 0.9

var _lanes: Array[float] = []
var _spawn_timer: Timer
var _rng := RandomNumberGenerator.new()
var defender: Defender

func _ready() -> void:
	_rng.randomize()
	var rect := get_viewport().get_visible_rect()
	var w := rect.size.x
	var h := rect.size.y
	_lanes = [w * 1.0 / 6.0, w * 3.0 / 6.0, w * 5.0 / 6.0]

	defender = defender_scene.instantiate() as Defender
	add_child(defender)
	defender.position = Vector2(w / 2.0, h - 80.0)

	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	_spawn_timer.wait_time = spawn_interval
	add_child(_spawn_timer)
	_spawn_timer.timeout.connect(_spawn_faller)
	_spawn_timer.start()

func _spawn_faller() -> void:
	if faller_scenes.is_empty():
		return
	var scene := faller_scenes[_rng.randi_range(0, faller_scenes.size() - 1)]
	var f := scene.instantiate()
	add_child(f)
	var lane_idx := _rng.randi_range(0, _lanes.size() - 1)
	f.position = Vector2(_lanes[lane_idx], -40.0)
	if f is Faller:
		(f as Faller).popped.connect(_on_faller_popped)

func _on_faller_popped(node: Node) -> void:
	# Apply bonuses & scoring here.
	if node is Gun and is_instance_valid(defender):
		var g := node as Gun
		defender.set_multi_shot(g.barrel_count)
		print("Gun collected: multi-shot set to ", g.barrel_count)
