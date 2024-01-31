extends Area2D
class_name Bullet

@export var projectile_speed = 1

var direction := Vector2.ZERO

func _process(delta):
	if (direction != Vector2.ZERO):
		var velocity = direction * projectile_speed
		global_position += velocity
		
func set_dir(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()
