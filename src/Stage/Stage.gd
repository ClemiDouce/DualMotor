extends Node2D

@onready var line_1: Line2D = $Line2D
@onready var line_2: Line2D = $Line2D2

@onready var player_1 := $Player_1 as Player
@onready var player_2:= $Player_2 as Player

@onready var label_score_p1: Label = %ScoreP1
@onready var label_score_p2: Label = %ScoreP2


var score_p1: int= 0:
	set(new_value):
		score_p1 = new_value
		label_score_p1.text = str(score_p1)

var score_p2: int= 0:
	set(new_value):
		score_p2 = new_value
		label_score_p2.text = str(score_p1)

var nearest_element : Node2D = null

func _process(_delta: float) -> void:	
	draw_item_line(player_1, line_1)
	draw_item_line(player_2, line_2)
		
		
func reset_line(line: Line2D):
	line.points[0] = Vector2.ZERO
	line.points[1] = Vector2.ZERO
	
func draw_item_line(player: Player, line: Line2D):
	# Get nearest emplacement of the player
	if player.is_occupied:
			if not player.motor_part is Loupe: 
				nearest_element = player.get_near_emplacement()
	else:
		nearest_element = player.get_near_motorpart()
	
	# Si y a un element proche
	if nearest_element:
		line.points[0] = player.global_position
		line.points[1] = nearest_element.global_position
	else: # Si pas d'element
		line.points[0] = Vector2.ZERO
		line.points[1] = Vector2.ZERO
