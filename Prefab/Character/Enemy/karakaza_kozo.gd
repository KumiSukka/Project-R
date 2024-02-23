extends CharacterBody2D
class_name karakaza_kozo

#Jaetaan joten nopeus korkeampi itseasiassa meinaa hitaampaa
var speed = 25
var health = 125
var player_chase = false
var player = null
var player_attack_zone = false
@onready var animationTree = $AnimationTree
@onready var enemySprite = $Sprite2D

func _physics_process(delta):
	deal_with_damage()
	
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
	if player_attack_zone:
		health = health - 20
		print("slime health = ", health)
		if health <=0:
			self.queue_free


func _on_enemy_hitbox_area_entered(area):
	if area.has_method("player"):
		player_attack_zone = true


func _on_enemy_hitbox_area_exited(area):
	if area.has_method("player"):
		player_attack_zone = false
