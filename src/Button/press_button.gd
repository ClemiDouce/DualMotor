extends Area2D
class_name PressButton

signal pressed
@onready var unpress_delay: Timer = $UnpressDelay
@onready var sprite: Sprite2D = $Sprite2D
@export var can_push: Player
@export var linked_motor: Motor
@export var tutorial_mode: bool = false



var is_pressed: bool = false:
	set(new_value):
		is_pressed = new_value
		sprite.frame = int(new_value)


func press(player_pressed: Player):
	if is_pressed or player_pressed != can_push:
		return
	if not tutorial_mode:
		unpress_delay.start()
		linked_motor.reset_motor()
	self.is_pressed = true
	pressed.emit()
	
	


func _on_unpress_delay_timeout() -> void:
	self.is_pressed = false
