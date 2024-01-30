extends CharacterBody2D

@export var move_speed = 100
@export var dash_speed = 300
@export var dash_duration = 0.3
@export var starting_direction : Vector2 = Vector2(0, 1)
#parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var Player_Sprite = $PlayerSprite
@onready var dash = $Dash
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var shoot_point = $Pointer/Shoot_point
@onready var pointer = $Pointer
@export var Bullet :PackedScene

func _ready():
	update_animation_parameters(starting_direction)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	update_animation_parameters(input_direction)
	
	#Flip
	if input_direction == Vector2.RIGHT:
		Player_Sprite.flip_h = false
	elif input_direction == Vector2.LEFT:
		Player_Sprite.flip_h = true
	#Dash	
	if Input.is_action_just_pressed("dash") && dash.can_dash && !dash.is_dashing():
		dash.start_dash(dash_duration)
		dash.end_dash()
	var speed = dash_speed if dash.is_dashing() else move_speed
	
	velocity = input_direction * speed

	
	

func _physics_process(delta):
	get_input()
	move_and_slide()
	pick_state()

func _unhandled_input(event): #Used for shooting kunai
	if event.is_action_pressed("attack"):
		shoot()

func shoot():
	#Figure how to use rotation of target/pointer for future control use cases
	var bullet_instance = Bullet.instantiate()
	add_child(bullet_instance)
	bullet_instance.global_position = shoot_point.global_position
	var target = get_global_mouse_position()
	var direction_to_target = bullet_instance.global_position.direction_to(target).normalized()
	bullet_instance.set_dir(direction_to_target)
	
func update_animation_parameters(move_input : Vector2):
	#Elä vaihda animaatio parameettrejä jos ei imputtia liikkua
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Dash/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
func pick_state(): #Mikä animaatio pitää olla päällä tällä hetkellä
	if (velocity != Vector2.ZERO) && !dash.is_dashing():
		state_machine.travel("Walk")
	elif (Input.is_action_just_pressed("dash")):
		state_machine.travel("Dash")
	elif (velocity == Vector2.ZERO):
		state_machine.travel("Idle")
