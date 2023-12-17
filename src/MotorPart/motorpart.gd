extends CharacterBody2D
class_name MotorPart

signal mounted

@onready var sprite: Sprite2D = $Sprite2D
@onready var delay_label: AnimatedSprite2D = $DelayLabel

var part_type: String = ""

var FRICTION = 250

var throwed = false
var falling = true
var is_mounted = false:
	set(new_value):
		is_mounted = new_value
		mounted.emit()
		

var can_pick: bool:
	get:
		return !is_mounted and !falling and !throwed

func create(_part_type: String, _position: Vector2):
	global_position = _position
	part_type = _part_type
	var texture_path = "res://assets/object/" + part_type.to_lower() + ".png"
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
	
	move_and_slide()
	
	self.velocity = self.velocity.move_toward(Vector2.ZERO, delta * FRICTION)
	
func throw(new_velocity: Vector2):
	self.velocity = new_velocity
	throwed = true

#func _on_delay_label_animation_finished() -> void:
	#delay_label.visible = false
	#bomb_explode()
	



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if !falling:
		mounted.emit()
		queue_free()
