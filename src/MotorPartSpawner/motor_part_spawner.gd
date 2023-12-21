@tool
extends Node2D

var Part = preload("res://src/MotorPart/motorpart.tscn")
var Powerup = preload("res://power_up.tscn")

@onready var spawn_timer: Timer = $SpawnTimer
@onready var power_up_timer: Timer = $PowerUpTimer


@export var MAX_PART_ON_SCREEN: int = 10
@onready var part_list: Node = $PartList
var last_part_spawned: Array[String] = []
var part_count: int:
	get:
		return part_list.get_children().size()

@export var spawn_zone : Rect2:
	set(new_value):
		spawn_zone = new_value
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(spawn_zone, Color.DARK_RED, false, 2)

func get_random_point() -> Vector2:
	var random_point = Vector2(
		randf_range(spawn_zone.position.x, spawn_zone.end.x),
		randf_range(spawn_zone.position.y, spawn_zone.end.y)
	)
	return random_point

func get_random_type() -> String:
	var list = Global.part_list.duplicate()
	var true_list = []
	for part in list:
		if not last_part_spawned.has(part):
			true_list.append(part)
	var type = true_list.pick_random()
	last_part_spawned.append(type)
	if last_part_spawned.size() > 5:
		last_part_spawned.pop_front()
	return type

func create_random_part():
	var instance = Part.instantiate()
	var type = get_random_type()
	part_list.add_child(instance)
	instance.create(type, get_random_point())
	instance.mounted.connect(_on_spawn_timer_timeout)
	
func create_random_power_up():
	var instance = Powerup.instantiate()
	part_list.add_child(instance)
	var type = "vision" if randf() > 0.5 else "speed"
	instance.create(type, get_random_point())

func _on_spawn_timer_timeout() -> void:
	if not part_count >= MAX_PART_ON_SCREEN:
		create_random_part()
		spawn_timer.start()

func _on_power_up_timer_timeout() -> void:
	create_random_power_up()
	power_up_timer.start()

func stop():
	clean_part()
	spawn_timer.stop()
	power_up_timer.start()
	last_part_spawned.clear()
	
func start():
	spawn_timer.start()
	power_up_timer.start()

func clean_part():
	for part in part_list.get_children():
		part.queue_free()
	


