extends Area2D

@onready var timer = $SpawnerDisable
@onready var circle =$spawn_circle
@export var can_spawn = false

func _on_timer_timeout():
	monitoring = true


func _on_body_entered(body):
	monitoring = false
	can_spawn = true
	timer.start()



func _on_spawner_disable_timeout():
	queue_free()
