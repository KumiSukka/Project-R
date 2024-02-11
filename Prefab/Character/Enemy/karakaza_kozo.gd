extends CharacterBody2D

#Jaetaan joten nopeus korkeampi itseasiassa meinaa hitaampaa
var speed = 30
var player_chase = false
var player = null
@onready var animationTree = $AnimationTree
@onready var enemy = $Sprite2D

func _physics_process(delta):
	if player_chase:
		#add here logick to chanse to chase animation state
		position += (player.position - position)/speed
		
		if(player.position.x - position.x) < 0:
			enemy.flip_h = true
		else:
			enemy.flip_h = false
	else:
		#Add here logick to change to idle
			pass

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
