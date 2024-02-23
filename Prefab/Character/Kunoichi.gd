extends CharacterBody2D
class_name Player

@export var health = 100
@export var move_speed = 100
@export var dash_speed = 300
@export var dash_duration = 0.3
var alive = true
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var Bullet :PackedScene
#parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var Player_Sprite = $PlayerSprite
@onready var dash = $Dash
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var pointer = $Pointer
@onready var shoot_rotation = $Pointer/Shoot_rotation
@onready var shoot_point = $Pointer/Shoot_point

#Ememy attack range and cooldown variables
var enemy_attack_range = false
var ememy_attack_cooldown = true


signal player_fired_bullet(bullet, position, direction)

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
	enemy_attack()

func _unhandled_input(event): #Used for shooting kunai
	if event.is_action_pressed("attack"):
		shoot()

func shoot():
	#Figure how to use rotation of target/pointer for future control use cases
	var bullet_instance = Bullet.instantiate()	
	var direction = (shoot_rotation.global_position - shoot_point.global_position).normalized()
	emit_signal("player_fired_bullet", bullet_instance, shoot_point.global_position, direction)
	
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

#Player will have player method that basicly does nothing but signalls that its a player same for enemy
func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_attack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_attack_range = false

func enemy_attack():
	if enemy_attack_range:
		print("player took damage")
	
