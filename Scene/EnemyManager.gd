extends Node2D


@export var SpawnAmount = 10
@export var spawner :PackedScene
@onready var tilemap = main


func _ready():
	spawncircles()
	pass


func spawncircles():
	for i in range(SpawnAmount):
		var new_spawner = spawner.instantiate()
		add_child(new_spawner)
#Selvitä miten sijoitat spawnatun vihollisen tilemappiin random kohtaan siten, että et sijoita kaikkia sinne samaan kohtaan
