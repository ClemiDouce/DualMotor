extends CharacterBody2D
class_name Motor

@onready var anchor_top_1:= $AnchorTop1 as MotorEmplacement
@onready var anchor_top_2:= $AnchorTop2 as MotorEmplacement
@onready var anchor_left:= $AnchorLeft as MotorEmplacement
@onready var anchor_right:= $AnchorRight as MotorEmplacement
@onready var anchor_down:= $AnchorDown as MotorEmplacement
@onready var drop_zone_detector: Area2D = $DetectDropZone
@onready var confetti_generator: GPUParticles2D = $ConfettiGenerator
@onready var cross_generator :GPUParticles2D= $CrossGenerator

@export var point_depart: Marker2D



var motor_bp : Dictionary = {}
var is_correct: bool:
	get:
		check_parts()
		return parts == motor_bp

var is_complete: bool:
	get:
		check_parts()
		return parts.values().all(func(x): return x != null)

var parts := {
	"top1": null,
	"top2": null,
	"down": null,
	"left": null,
	"right": null
}

func _ready():
	reset_motor()

func check_parts():
	parts["top1"] = anchor_top_1.get_part()
	parts["top2"] = anchor_top_2.get_part()
	parts["left"] = anchor_left.get_part()
	parts["right"] = anchor_right.get_part()
	parts["down"] = anchor_down.get_part()
	
func detect_drop_zone():
	var temp : Array[Area2D] = drop_zone_detector.get_overlapping_areas()
	if temp:
		var zone : Area2D = temp[0]
		if zone.name == "DropZone":
			if is_correct:
				confetti_generator.emitting = true
				
			else:
				cross_generator.emitting = true
				
			await get_tree().create_timer(2).timeout
			reset_motor()
		elif zone.name == "TrashZone":
			print("Highway to the Trash Zone")

func generate_random_motor():
	var list_part : Array = Global.part_list
	list_part.shuffle()
	var new_bp = {
		"top1": list_part[0],
		"top2": list_part[1],
		"down": list_part[2],
		"left": list_part[3],
		"right": list_part[4]
	}
	return new_bp

func reset_motor():
	motor_bp = generate_random_motor()
	parts = Global.clean_motor.duplicate()
	for el in get_children():
		if el is MotorEmplacement:
			el.reset()
	anchor_down.set_part_hint(motor_bp["down"])
	anchor_left.set_part_hint(motor_bp["left"])
	anchor_right.set_part_hint(motor_bp["right"])
	anchor_top_1.set_part_hint(motor_bp["top1"])
	anchor_top_2.set_part_hint(motor_bp["top2"])
	await get_tree().create_timer(0.5).timeout
	if point_depart:
		global_position = point_depart.global_position
