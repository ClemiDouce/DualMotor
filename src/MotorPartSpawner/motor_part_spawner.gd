@tool
extends Node2D

var Part = preload("res://src/MotorPart/motorpart.tscn")


@export var MAX_PART_ON_SCREEN: int = 10
@onready var part_list: Node = $PartList
var part_count: int:
	get:
		return part_list.get_children().size()

@export var spawn_zone : Rect2:
	set(new_value):
		spawn_zone = new_value
		queue_redraw()

#func _ready() -> void:
	#var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	#var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	#spawn_zone = Rect2(
		#position,
		#Vector2(window_width, window_height)
	#)

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(spawn_zone, Color.DARK_RED, false, 2)

func get_random_point() -> Vector2:
	var random_point = Vector2(
		randf_range(spawn_zone.position.x, spawn_zone.end.x),
		randf_range(spawn_zone.position.y, spawn_zone.end.y)
	)
	return random_point

func create_random_part():
	var instance = Part.instantiate()
	var type = Global.part_list.pick_random()
	part_list.add_child(instance)
	instance.create(type, get_random_point())
	instance.mounted.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	if not part_count >= MAX_PART_ON_SCREEN:
		create_random_part()
		$SpawnTimer.start()
	
	
