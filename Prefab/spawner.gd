extends Area2D

var enemy1 := preload("res://Prefab/Character/Enemy/karakaza_kozo.tscn")
@onready var timer = $SpawnerDisable
@onready var circle =$spawn_circle

func _on_timer_timeout():
	monitoring = true


func _on_body_entered(body):
	monitoring = false
	timer.start()
	



func _on_spawner_disable_timeout():
	circle.visible = false
	var new_enemy = enemy1.instantiate()
	add_child(new_enemy)
