extends Node2D


@export var SpawnAmount = 10
@onready var Spawn = $EnemyManager/Spawner
@export var karakaza_kozo :PackedScene



func _on_spawner_body_entered(body):
	var spawned_enemy = karakaza_kozo.instantiate()
	add_child(spawned_enemy)
	
#Selvitä miten sijoitat spawnatun vihollisen tilemappiin random kohtaan siten, että et sijoita kaikkia sinne samaan kohtaan
