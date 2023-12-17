extends CharacterBody2D
class_name MotorPart

@onready var sprite: Sprite2D = $Sprite2D
@onready var delay_label: AnimatedSprite2D = $DelayLabel

var object_type: String = ""

var FRICTION = 250

var falling = true
var is_mounted = false
var throwed = false

func _ready():
	var texture_path = "res://assets/object/" + object_type.to_lower() + ".png"
	self.sprite.texture = load(texture_path)
	var fall_d = randf_range(1.1, 2.5)
	fall(fall_d)

func fall(fall_duration:float):
	global_position.y -= 100 
	scale = Vector2(2,2)
	var fall_tween = create_tween().set_parallel(true)
	fall_tween.tween_property(self, "position", Vector2.DOWN * 100, fall_duration).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	fall_tween.tween_property(self, "scale", Vector2(1,1), fall_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	await fall_tween.finished
	falling = false

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		if throwed == true:
			throwed = false
			if object_type == "BOMB":
				start_timer()
	
	move_and_slide()
	
	self.velocity = self.velocity.move_toward(Vector2.ZERO, delta * FRICTION)
	
func throw(new_velocity: Vector2):
	self.velocity = new_velocity
	throwed = true

func start_timer():
	delay_label.visible = true
	delay_label.play("decompte")

func bomb_explode():
	var to_bomb : Array[Node2D] = $ExplodeArea.get_overlapping_bodies()
	if to_bomb:
		for bombed in to_bomb:
			bombed.get_bombed(self.position)
	queue_free()


func _on_delay_label_animation_finished() -> void:
	delay_label.visible = false
	bomb_explode()
	

