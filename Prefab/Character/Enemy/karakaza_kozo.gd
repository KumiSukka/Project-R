extends CharacterBody2D
class_name karakaza_kozo

#Jaetaan joten nopeus korkeampi itseasiassa meinaa hitaampaa
var speed = 45
var health = 125
var player_chase = false
var player = null
@onready var animationTree = $AnimationTree
@onready var enemySprite = $Sprite2D

func _physics_process(delta):
	if player_chase:
		#add here logick to chanse to chase animation state
		position += (player.position - position)/speed
		
		if(player.position.x - position.x) < 0:
			enemySprite.flip_h = true
		else:
			enemySprite.flip_h = false
	else:
		#Add here logick to change to idle
			pass

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

#Enemy will have enemy method that basicly does nothing but signalls that its a enemy same for player
func enemy():
	pass

func deal_with_damage():
		health = health - 20
		print("enemy health = ", health)
		if health <=0:
			queue_free()





