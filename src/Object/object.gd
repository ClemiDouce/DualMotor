extends Area2D
class_name MotorPart

@onready var sprite: Sprite2D = $Sprite2D
@onready var delay_label: AnimatedSprite2D = $DelayLabel

var velocity : Vector2 = Vector2.ZERO
var FRICTION = 250

var mounted = false
var throwed = false

@export_enum("FLAG", "CACTUS", "PISTON", "SPIKE", "KEY", "PANNEL", "LEVER", "MUSHROOM", "BOMB") var object_type : String

func _ready():
	var texture_path = "res://assets/object/" + object_type.to_lower() + ".png"
	self.sprite.texture = load(texture_path)

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		if throwed == true:
			throwed = false
			if object_type == "BOMB":
				start_timer()
	
	self.global_position += velocity * delta
	
	self.velocity = self.velocity.move_toward(Vector2.ZERO, delta * FRICTION)
	
func throw(new_velocity: Vector2):
	self.velocity = new_velocity
	throwed = true

func start_timer():
	delay_label.visible = true
	delay_label.play("decompte")

func bomb_explode():
	var to_bomb : Array[Node2D] = $ExplodeArea.get_overlapping_bodies()
	to_bomb
	if to_bomb:
		for bombed in to_bomb:
			bombed.get_bombed(self.position)
	queue_free()

func _on_delay_label_frame_changed() -> void:
	print("tic")


func _on_delay_label_animation_finished() -> void:
	#await get_tree().create_timer(1).timeout
	delay_label.visible = false
	bomb_explode()
	

