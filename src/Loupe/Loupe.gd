extends Node2D
class_name SocleLoupe

@onready var loupe: CharacterBody2D = $Loupe
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var spring_timer: Timer = $Timer

var is_taken: bool:
	get:
		return player != null

var distance_to_magn: float:
	get:
		return loupe.position.length()

var player: Player = null

func take(new_owner: Player):
	player = new_owner
	
func release():
	player = null
	var tweener = create_tween().tween_property(loupe, "position", Vector2.ZERO, 0.5)
	tweener.set_ease(Tween.EASE_OUT)
	tweener.set_trans(Tween.TRANS_BOUNCE)
	
	
func _process(delta: float):
	var spring = loupe.global_position.direction_to(position)
	ray_cast_2d.target_position = loupe.position
	
	if is_taken:
		$Force.target_position = spring * distance_to_magn
		player.contrainte = spring * distance_to_magn

