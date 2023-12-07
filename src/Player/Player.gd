extends CharacterBody2D

@onready var grab_area: Area2D = $GrabArea
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var object_marker: Marker2D = $ObjectMarker

@export_enum("P1", "P2") var player_number : int
var object : Node2D = null
var STRENGTH = 200
var direction : Vector2 = Vector2.ZERO

var is_stunned = false

const SPEED = 75.0

func _ready() -> void:
	sprite.sprite_frames = load("res://src/Player/player_"+ str(player_number+1) +"_spriteframe.tres")
	$StunDelay.timeout.connect(func(): is_stunned = false)

func _physics_process(delta):
	if not is_stunned:
		direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
		velocity = direction * SPEED
		if direction != Vector2.ZERO:
			var anim_to_play = "run_with" if object else "run"
			sprite.play(anim_to_play)
		else:
			var anim_to_play = "idle_with" if object else "idle"
			sprite.play(anim_to_play)
		
		if direction.x:
			sprite.scale.x = sign(direction.x)
		
		if object:
			object.global_position = object_marker.global_position
	else:
		self.velocity = self.velocity.move_toward(Vector2.ZERO, 1)
	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_1"):
		grab_object()

func get_bombed(bomb_position: Vector2, push_force: int = 30, stun_delay: int = 4):
	#TODO: Effet de stun de bombe
	var bomb_direction = bomb_position.direction_to(self.position)
	velocity += bomb_direction * push_force
	is_stunned = true
	$StunDelay.start(stun_delay)
	



func grab_object():
	if object == null: # Si pas d'objet dans les mains
		var pot_object = grab_area.get_overlapping_areas()
		print(pot_object)
		if pot_object:
			for x in pot_object:
				if x is MotorPart and not (x as MotorPart).mounted:
					self.object = x
					return
	else: # Si objet déja dans les mains
		if direction != Vector2.ZERO:
			self.object.global_position = $ThrowMarker.global_position + (direction * 4)
			self.object.throw(direction * STRENGTH)
		else:
			self.object.global_position = $ThrowMarker.global_position
		
		self.object = null
