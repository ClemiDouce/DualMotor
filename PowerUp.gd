extends Area2D
class_name PowerUp

@onready var sprite: Sprite2D = $Sprite2D

var power_up_type = ""
var falling = false

func get_effect(player: Player):
	match(power_up_type):
		"vision":
			player.effect_part_vision()
		"speed":
			player.effect_speed()
	queue_free()

func create(_type: String, _position: Vector2):
	global_position = _position
	power_up_type = _type
	var texture_path = "res://assets/powerup/" + power_up_type.to_lower() + ".png"
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
