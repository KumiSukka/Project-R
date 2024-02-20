extends Node2D


@export var SpawnAmount = 10
@export var karakaza_kozo :PackedScene
@export var spawner :PackedScene



func _ready():
	spawncircles()
	pass

func _on_spawner_body_entered(body):
	var spawned_enemy = karakaza_kozo.instantiate()
	add_child(spawned_enemy)
	pass

func spawncircles():
	for i in range(SpawnAmount):
		var new_spawner = spawner.instantiate()
		add_child(new_spawner)
#Selvitä miten sijoitat spawnatun vihollisen tilemappiin random kohtaan siten, että et sijoita kaikkia sinne samaan kohtaan
