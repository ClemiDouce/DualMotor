extends Node2D

@onready var line: Line2D = $Line2D
@onready var player: CharacterBody2D = $Player

var close_elements: Array[Node2D] = []
var nearest_element : Node2D = null

func _process(delta: float) -> void:
	if player.is_occupied():
		draw_item_line()
	else:
		reset_line()
		
func reset_line():
	line.points[0] = Vector2.ZERO
	line.points[1] = Vector2.ZERO
	
func draw_item_line():
	if nearest_element:
		line.points[0] = player.global_position
		line.points[1] = nearest_element.global_position
	
	var temp_close = $Player/DetectArea.get_overlapping_bodies()
	
	#if temp_close != close_elements:
		# Stocker les elements
	close_elements = temp_close
	
	# Get closest
	if close_elements.size() > 0:
		# Stocker le premier element recupéré
		var temp_nearest = close_elements[0]
		# Stocker la première distance
		var distance_nearest = player.position.distance_to(temp_nearest.position)
		# Pour chaque élément dans les elements proches
		for el in close_elements:
			# distance entre le joueur et 'el'
			var temp_distance = player.position.distance_to(el.global_position)
			# Si la distance temporaire est inferieur a celle de l'element actuelle
			# et que c'est pas le meme element 
			if temp_distance < distance_nearest:
				temp_nearest = el
				distance_nearest = temp_distance
		nearest_element = temp_nearest
	elif nearest_element != null:
		nearest_element = null
		line.points[0] = Vector2.ZERO
		line.points[1] = Vector2.ZERO
