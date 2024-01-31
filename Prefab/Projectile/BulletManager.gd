extends Node2D
class_name BulletManager
func handle_bullet_spawned(bullet, position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_dir(direction)
