extends Area2D

var enemy1 := preload("res://Prefab/Character/Enemy/karakaza_kozo.tscn")


func _on_timer_timeout():
	monitoring = true


func _on_body_entered(body):
	queue_free()
