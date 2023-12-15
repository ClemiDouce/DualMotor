extends CharacterBody2D
class_name Player

@onready var grab_area: Area2D = $GrabArea
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var motor_part_marker: Marker2D = $ObjectMarker
@onready var detect_area: Area2D = $DetectArea

@export_enum("P1", "P2") var player_number : int
var motor_part : Node2D = null
var STRENGTH = 200
var direction : Vector2 = Vector2.ZERO

var is_stunned = false
var is_occupied: bool:
	get:
		return motor_part != null

const SPEED = 75.0

func _ready() -> void:
	sprite.sprite_frames = load("res://src/Player/player_"+ str(player_number+1) +"_spriteframe.tres")
	$StunDelay.timeout.connect(func(): is_stunned = false)

func _physics_process(_delta):
	if not is_stunned:
		direction = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down")
		velocity = direction * SPEED
		if direction != Vector2.ZERO:
			var anim_to_play = "run_with" if motor_part else "run"
			sprite.play(anim_to_play)
		else:
			var anim_to_play = "idle_with" if motor_part else "idle"
			sprite.play(anim_to_play)
		
		if direction.x:
			sprite.scale.x = sign(direction.x)
		
		if motor_part:
			motor_part.global_position = motor_part_marker.global_position
	else:
		self.velocity = self.velocity.move_toward(Vector2.ZERO, 1)
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("action_1"):
		grab_motor_part()
	
func get_bombed(bomb_position: Vector2, push_force: int = 30, stun_delay: int = 4):
	# TODO: Effet de stun de bombe
	var bomb_direction = bomb_position.direction_to(self.position)
	velocity += bomb_direction * push_force
	is_stunned = true
	$StunDelay.start(stun_delay)

func get_near_motorpart() -> MotorPart:
	var close_elements = grab_area.get_overlapping_bodies()
	
	# Get closest
	if close_elements.size() > 0:
		# Stocker le premier element recupéré
		var temp_nearest : Node2D = null
		# Stocker la première distance
		var distance_nearest : float = 10000
		# Pour chaque élément dans les elements proches
		for el in close_elements:
			if (el is MotorPart and el.is_mounted) or (el is Motor and not (el as Motor).is_complete) or el is MotorEmplacement:
				continue
			# distance entre le joueur et 'el'
			var temp_distance = self.position.distance_to(el.global_position)
			# Si la distance temporaire est inferieur a celle de l'element actuelle
			# et que c'est pas le meme element 
			if temp_distance < distance_nearest:
				temp_nearest = el
				distance_nearest = temp_distance
		return temp_nearest
	else:
		return null

func get_near_emplacement() -> MotorEmplacement:
	
	var close_elements = detect_area.get_overlapping_bodies()
	
	# Get closest
	if close_elements.size() > 0:
		# Stocker le premier element recupéré
		var temp_nearest : MotorEmplacement = null
		# Stocker la première distance
		var distance_nearest : float = 10000
		# Pour chaque élément dans les elements proches
		for el in close_elements:
			if not el is MotorEmplacement or (el as MotorEmplacement).is_occupied:
				continue
			# distance entre le joueur et 'el'
			var temp_distance = self.position.distance_to(el.global_position)
			# Si la distance temporaire est inferieur a celle de l'element actuelle
			# et que c'est pas le meme element 
			if temp_distance < distance_nearest:
				temp_nearest = el
				distance_nearest = temp_distance
		return temp_nearest
	else:
		return null

func grab_motor_part():
	if motor_part == null: # Si pas d'objet dans les mains
		var near_motor_part = get_near_motorpart()
		if near_motor_part:
			self.motor_part = near_motor_part
	else: # Si objet déja dans les mains
		if motor_part is MotorPart:
			var nearest : MotorEmplacement = get_near_emplacement()
			print(nearest)
			if nearest != null:
				nearest.mount(self, self.motor_part)
			elif direction != Vector2.ZERO:
				self.motor_part.global_position = $ThrowMarker.global_position + (direction * 4)
				self.motor_part.throw(direction * STRENGTH)
			else:
				self.motor_part.global_position = $ThrowMarker.global_position
		
		elif motor_part is Motor:
			self.motor_part.global_position = $ThrowMarker.global_position
			(motor_part as Motor).detect_drop_zone()
		
		self.motor_part = null
