extends Area2D

var enemy1 := preload("res://Prefab/Character/Enemy/karakaza_kozo.tscn")
@onready var timer = $SpawnerDisable

func _on_timer_timeout():
	monitoring = true


func _on_body_entered(body):
	monitoring = false
	timer.start()
	



func _on_spawner_disable_timeout():
	queue_free()
