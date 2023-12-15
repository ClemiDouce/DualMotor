extends CharacterBody2D
class_name Motor

@onready var anchor_top_1:= $AnchorTop1 as MotorEmplacement
@onready var anchor_top_2:= $AnchorTop2 as MotorEmplacement
@onready var anchor_left:= $AnchorLeft as MotorEmplacement
@onready var anchor_right:= $AnchorRight as MotorEmplacement
@onready var anchor_down:= $AnchorDown as MotorEmplacement
@onready var drop_zone_detector: Area2D = $DetectDropZone
@onready var confetti: GPUParticles2D = $ConfettiGenerator



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
	motor_bp = {
		"top1": "KEY",
		"top2": "SPIKE",
		"down": "CACTUS",
		"left": "PISTON",
		"right": "PANNEL"
	}

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
				confetti.emitting = true
				await get_tree().create_timer(2).timeout
				queue_free()
			else:
				print("NAY")
		elif zone.name == "TrashZone":
			print("Highway to the Trash Zone")
