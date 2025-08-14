extends Node2D

@export var attacker_scenes: Array[PackedScene]
@export var defender_scene: PackedScene
@export var spawn_interval: float = 0.9

var _lanes: Array[float] = []
var _spawn_timer: Timer
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	var rect := get_viewport().get_visible_rect()
	var w := rect.size.x
	var h := rect.size.y
	_lanes = [w * 1.0 / 6.0, w * 3.0 / 6.0, w * 5.0 / 6.0]

	var defender := defender_scene.instantiate() as Node2D
	add_child(defender)
	defender.position = Vector2(w / 2.0, h - 80.0)

	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	_spawn_timer.wait_time = spawn_interval
	add_child(_spawn_timer)
	_spawn_timer.timeout.connect(_spawn_attacker)
	_spawn_timer.start()

func _spawn_attacker() -> void:
	if attacker_scenes.is_empty():
		return
	var scene := attacker_scenes[_rng.randi_range(0, attacker_scenes.size() - 1)]
	var a := scene.instantiate()
	add_child(a)
	var lane_idx := _rng.randi_range(0, _lanes.size() - 1)
	a.position = Vector2(_lanes[lane_idx], -40.0)
	if a is Attacker:
		(a as Attacker).destroyed.connect(_on_attacker_destroyed)

func _on_attacker_destroyed(v: int) -> void:
	# Hook for scoring/effects
	print("Destroyed attacker with value: ", v)
