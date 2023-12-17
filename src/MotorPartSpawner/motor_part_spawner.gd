@tool
extends Node2D

enum PART_TYPE {FLAG, CACTUS, PISTON, SPIKE, KEY, PANNEL, LEVER, MUSHROOM, BOMB}


var spawn_zone : Rect2:
	set(new_value):
		spawn_zone = new_value
		queue_redraw()
		
func _ready() -> void:
	var window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	spawn_zone = Rect2(
		position+Vector2(10,10),
		Vector2(window_width, window_height)-Vector2(20,15)
	)

func _draw() -> void:
	#if Engine.is_editor_hint():
	draw_rect(spawn_zone, Color.DARK_RED, false, 2)

func get_random_point() -> Vector2:
	var random_point = Vector2(
		randi_range(position.x, position.x+spawn_zone.size.x),
		randi_range(position.y, position.y+spawn_zone.size.y),
	)
	return random_point

func spawn_object(new_part: MotorPart):
	add_child(new_part)

func create_random_part():
	pass

func _on_spawn_timer_timeout() -> void:
	var new_part : MotorPart = create_random_part()
	spawn_object(new_part)
	
