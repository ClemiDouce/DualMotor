extends Node2D
class_name SocleLoupe

@onready var loupe: CharacterBody2D = $Loupe
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var spring_timer: Timer = $Timer
@onready var elastic: Line2D = $Line2D


var is_taken: bool:
	get:
		return player != null

var distance_to_magn: float:
	get:
		return loupe.position.length()

var player: Player = null
@export var DISTANCE_MAX = 100 

func take(new_owner: Player):
	player = new_owner
	
func release():
	player = null
	var tweener = create_tween().tween_property(loupe, "position", Vector2.ZERO, 0.8)
	tweener.set_ease(Tween.EASE_OUT)
	tweener.set_trans(Tween.TRANS_ELASTIC)
	
	
func _process(delta: float):
	var spring = loupe.global_position.direction_to(position)
	elastic.points[0] = Vector2.ZERO
	elastic.points[1] = loupe.position
	
	elastic.width = Global.remap_range(distance_to_magn, 0, DISTANCE_MAX, 6, 1)
	elastic.self_modulate.s = Global.remap_range(distance_to_magn, 0, DISTANCE_MAX, 0, 1)
	
	if is_taken:
		player.contrainte = spring * ((distance_to_magn * player.SPEED) / DISTANCE_MAX)

