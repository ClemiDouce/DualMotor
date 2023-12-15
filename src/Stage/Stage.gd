extends Node2D

@onready var line: Line2D = $Line2D
@onready var player := $Player as Player

var nearest_element : Node2D = null

func _process(_delta: float) -> void:	
	draw_item_line()
		
		
func reset_line():
	line.points[0] = Vector2.ZERO
	line.points[1] = Vector2.ZERO
	
func draw_item_line():
	# Get nearest emplacement of the player
	if player.is_occupied:
		#print("Est occupée")
		nearest_element = player.get_near_emplacement()
	else:
		#print("N'est pas occupé")
		nearest_element = player.get_near_motorpart()
	
	# Si y a un element proche
	if nearest_element:
		line.points[0] = player.global_position
		line.points[1] = nearest_element.global_position
	else: # Si pas d'element
		line.points[0] = Vector2.ZERO
		line.points[1] = Vector2.ZERO
