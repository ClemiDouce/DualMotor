extends Node2D

@onready var line_1: Line2D = $Line2D
@onready var line_2: Line2D = $Line2D2

@onready var press_button_p_1: PressButton = %PressButton_p1
@onready var press_button_p_2: PressButton = %PressButton_p2


@onready var player_1 := $Player_1 as Player
@onready var player_2 := $Player_2 as Player

@onready var label_score_p1: Label = %ScoreP1
@onready var label_score_p2: Label = %ScoreP2
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var motor_part_spawner: Node2D = $MotorPartSpawner


@export var MAX_GAME_TIME := 120
var game_time = 0

enum GAME_STATE {TUTORIAL, TRANSITION, GAME, RESULT}
var game_state: GAME_STATE = GAME_STATE.TUTORIAL:
	set(new_value):
		game_state = new_value
		change_game_state()
		
		
func change_game_state():
	match(game_state):
		GAME_STATE.TUTORIAL:
			$TutorialLayer.visible = true
		GAME_STATE.TRANSITION:
			motor_part_spawner.stop()
			$TutorialLayer.visible = false
			$TransitionLayer.visible = true
			animation_player.play("start_game")
		GAME_STATE.GAME:
			motor_part_spawner.start()
			$GameTime.start()
			$GameLayer.visible = true
			$TransitionLayer.visible = false
		GAME_STATE.RESULT:
			$GameLayer.visible = false
			show_winner()

var score_p1: int= 0:
	set(new_value):
		score_p1 = new_value
		label_score_p1.text = str(score_p1)

var score_p2: int= 0:
	set(new_value):
		score_p2 = new_value
		label_score_p2.text = str(score_p2)

var nearest_element_p1 : Node2D = null
var nearest_element_p2 : Node2D = null

func _ready():
	self.game_state = GAME_STATE.TUTORIAL

func _process(_delta: float) -> void:	
	draw_item_line(player_1, line_1, nearest_element_p1)
	draw_item_line(player_2, line_2, nearest_element_p2)
		
		
func reset_line(line: Line2D):
	line.points[0] = Vector2.ZERO
	line.points[1] = Vector2.ZERO
	
func draw_item_line(player: Player, line: Line2D, nearest_element: Node2D):
	# Get nearest emplacement of the player
	if player.is_occupied and not player.motor_part is Loupe:
		nearest_element = player.get_near_emplacement()
	else:
		nearest_element = player.get_near_motorpart()
	
	# Si y a un element proche
	if nearest_element:
		line.points[0] = player.global_position
		line.points[1] = nearest_element.global_position
	else: # Si pas d'element
		reset_line(line)


func _on_motor_p_2_verified(correct: bool) -> void:
	if correct:
		self.score_p2 += 1

func _on_motor_p_1_verified(correct: bool) -> void:
	if correct:
		self.score_p1 += 1


func _on_press_button_pressed() -> void:
	if game_state == GAME_STATE.TUTORIAL:
		if %PressButton_p1.is_pressed and %PressButton_p2.is_pressed:
			self.game_state = GAME_STATE.TRANSITION
			%PressButton_p1.is_pressed = false
			%PressButton_p1.tutorial_mode = false
			%PressButton_p2.is_pressed = false
			%PressButton_p2.tutorial_mode = false			
		
func translate_winner(player: Player):
	var fall_tween = create_tween().set_parallel(true)
	fall_tween.tween_property(player, "position", $WinnerEmplacement.global_position, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	fall_tween.tween_property(player, "scale", Vector2(2,2), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	await fall_tween.finished
	$ScoreLayer.visible = true

func show_winner():
	motor_part_spawner.stop()
	$SocleLoupe.visible = false

	if score_p1 > score_p2:
		%Winner.text = "Player 1"
		translate_winner(player_1)
	else:
		%Winner.text = "Player 2"
		translate_winner(player_2)

func _on_game_time_timeout() -> void:
	if game_time < MAX_GAME_TIME:
		game_time += 1
		%GameTime.text = "Time Left : " + str(MAX_GAME_TIME - game_time)
	else:
		game_state = GAME_STATE.RESULT
