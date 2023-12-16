extends StaticBody2D
class_name MotorEmplacement

signal has_something

var part_mounted : String = ""

@onready var mounted_object: Node2D = $MountedObject

# Si un objet est actuellement monté
var is_occupied :bool:
	get:
		return mounted_object.get_child_count() > 0

func mount(player:Player, node: MotorPart):
	part_mounted = node.object_type
	node.reparent(mounted_object, false)
	node.transform = Transform2D(mounted_object.rotation, Vector2.ZERO)
	node.is_mounted = true
	
func unmount(player: Player):
	if not is_occupied:
		return
		
	var motor_part = find_child("Object")
	player.object = motor_part
	remove_child(motor_part)
	part_mounted = ""

func get_part():
	if not is_occupied:
		return null
	
	return part_mounted

func get_part_node() -> Node:
	if not is_occupied:
		return
		
	return mounted_object.get_children()[0]
	
func reset():
	part_mounted = ""
	get_part_node().queue_free()
