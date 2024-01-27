extends CharacterBody2D

@export var speed = 150
@export var starting_direction : Vector2 = Vector2(0, 1)
#parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var Player_Sprite = $PlayerSprite
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(starting_direction)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	update_animation_parameters(input_direction)
	velocity = input_direction * speed
	#Flip
	if input_direction == Vector2.RIGHT:
		Player_Sprite.flip_h = false
	elif input_direction == Vector2.LEFT:
		Player_Sprite.flip_h = true

	
	

func _physics_process(delta):
	get_input()
	move_and_slide()
	pick_state()

func update_animation_parameters(move_input : Vector2):
	#Elä vaihda animaatio parameettrejä jos ei imputtia liikkua
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
func pick_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
