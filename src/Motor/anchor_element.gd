extends Area2D
class_name MotorEmplacement

signal has_something

var part_mounted : String = ""

@onready var mounted_object: Node2D = $MountedObject
@onready var part_hint: Sprite2D = $PartHint

# Si un objet est actuellement monté
var is_occupied :bool:
	get:
		return mounted_object.get_child_count() > 0

func mount(node: MotorPart):
	part_mounted = node.part_type
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
	if is_occupied:
		get_part_node().queue_free()

func set_part_hint(part_name: String):
	part_hint.texture = load("res://assets/object/"+part_name.to_lower()+".png")

func _on_show_area_area_entered(_area: Area2D) -> void:
	if not is_occupied:
		part_hint.visible = true


func _on_show_area_area_exited(_area: Area2D) -> void:
	if not (owner as Motor).under_show_effect:
		part_hint.visible = false
