extends CharacterBody2D
class_name Loupe

signal taken
signal released

var contrainte : Vector2 = Vector2.ZERO

func take(new_owner: Player):
	taken.emit(new_owner)
	
func release():
	released.emit()

func _process(delta: float):
	velocity += contrainte
	move_and_slide()
