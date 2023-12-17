@tool
extends Node2D

var Part = preload("res://src/MotorPart/motorpart.tscn")

@onready var part_list: Node = $PartList


var spawn_zone : Rect2:
	set(new_value):
		spawn_zone = new_value
		queue_redraw()

func _ready() -> void:
	var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	spawn_zone = Rect2(
		position+Vector2(3,3),
		Vector2(window_width, window_height)-Vector2(10,10)
	)

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(spawn_zone, Color.DARK_RED, false, 2)

func get_random_point() -> Vector2:
	var random_point = Vector2(
		randf_range(position.x, position.x+spawn_zone.size.x),
		randf_range(position.y, position.y+spawn_zone.size.y),
	)
	return random_point

func create_random_part():
	var instance = Part.instantiate()
	var type = Global.part_list.pick_random()
	part_list.add_child(instance)
	instance.create(type, get_random_point())

func _on_spawn_timer_timeout() -> void:
	create_random_part()
	
	
