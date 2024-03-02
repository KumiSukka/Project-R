extends Area2D
class_name Bullet

@export var projectile_speed = 1

@onready var kill_timer = $KillTimer

var direction := Vector2.ZERO

func _ready():
	kill_timer.start()
	
	
func _process(delta):
	if (direction != Vector2.ZERO):
		var velocity = direction * projectile_speed
		global_position += velocity
		
func set_dir(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_kill_timer_timeout(): #Käytä queue_free elä ikinä vain free
	queue_free()

func _on_body_entered(body):
	if body.has_method("deal_with_damage"):
		body.deal_with_damage()
		
