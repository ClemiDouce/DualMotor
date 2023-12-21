extends CharacterBody2D
class_name Player

@onready var grab_area: Area2D = $GrabArea
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var motor_part_marker: Marker2D = $ObjectMarker
@onready var detect_area: Area2D = $DetectArea
@onready var loupe_delay: Timer = $LoupeDelay

@export_enum("P1", "P2") var player_number : int
var move_set : PlayerMoveSet
var SPEED : float = 125.0
@export var motor : Motor

var motor_part : Node2D = null
var STRENGTH = 200
var direction : Vector2 = Vector2.ZERO
var contrainte : Vector2 = Vector2.ZERO
var is_stunned = false

var is_occupied: bool:
	get:
		return motor_part != null

func _ready() -> void:
	sprite.sprite_frames = load("res://src/Player/player_"+ str(player_number+1) +"_spriteframe.tres")
	move_set = load("res://src/Player/player_"+str(player_number+1)+"_move_set.tres")

func _physics_process(_delta):
	direction = Input.get_vector(
		move_set.move_left,
		move_set.move_right,
		move_set.move_up,
		move_set.move_down)
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
	
	velocity += contrainte
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(move_set.action_1):
		grab_motor_part()

func get_near_motorpart() -> MotorPart:
	var close_elements = grab_area.get_overlapping_bodies()
	close_elements.append_array(grab_area.get_overlapping_areas())
	# Get closest²
	if close_elements.size() > 0:
		# Stocker le premier element recupéré
		var temp_nearest : Node2D = null
		# Stocker la première distance
		var distance_nearest : float = 10000
		# Pour chaque élément dans les elements proches
		for el in close_elements:
			if (el is Motor and el.can_pick(self)) or (el is MotorPart and el.can_pick) or el is Loupe or (el is PowerUp and el.falling == false):
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
	
	var close_elements = detect_area.get_overlapping_areas()
	
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
	check_button()
	if motor_part == null: # Si pas d'objet dans les mains
		var near_motor_part = get_near_motorpart()
		if near_motor_part:
			if near_motor_part is PowerUp:
				(near_motor_part as PowerUp).get_effect(self)
			if near_motor_part is Loupe:
				(near_motor_part as Loupe).take(self)
				loupe_delay.start()
			
			if near_motor_part is MotorPart:
				if near_motor_part.lifted_by != null:
				# Vol au joueur
					print("Vol!")
					near_motor_part.lifted_by.motor_part = null
				
				near_motor_part.lifted_by = self
				
			if !near_motor_part is PowerUp:
				self.motor_part = near_motor_part
				
	else: # Si objet déja dans les mains
		if motor_part is MotorPart:
			var nearest : MotorEmplacement = get_near_emplacement()
			if nearest != null:
				nearest.mount(self.motor_part)
			elif direction != Vector2.ZERO:
				self.motor_part.global_position = $ThrowMarker.global_position + (direction * 4)
				self.motor_part.throw(direction * STRENGTH)
			else:
				self.motor_part.global_position = $ThrowMarker.global_position
		
		elif motor_part is Motor:
			self.motor_part.global_position = $ThrowMarker.global_position
			(motor_part as Motor).detect_drop_zone()
		elif motor_part is Loupe:
			drop_the_loupe()
		self.motor_part = null

func drop_the_loupe():
	if motor_part != null and motor_part is Loupe:
		contrainte = Vector2.ZERO
		(motor_part as Loupe).release()
		self.motor_part = null
		
func check_button():
	var areas : Array[Area2D] = grab_area.get_overlapping_areas()
	if areas:
		for area in areas:
			if area is PressButton:
				(area as PressButton).press(self)

func effect_speed():
	$SpeedEffectDelay.start()
	self.SPEED = 180
	
func effect_part_vision():
	motor.show_effect()

func _on_speed_effect_delay_timeout() -> void:
	self.SPEED = 125
