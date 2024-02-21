extends Node2D


@export var SpawnAmount = 10
@export var spawner :PackedScene
@export var enemy1 :PackedScene
@onready var tilemap = main


func _ready():
	spawncircles()
	pass
	

func spawncircles(): #Spawnaa vihollisen vaikak lukee circle nyt vaan vihollinen hajoaa jos spawnaa circlen lapsena
	for i in range(SpawnAmount):
		var new_enemy = enemy1.instantiate()
		add_child(new_enemy)


#Pitää spawnata vihollinen eka, jotta systeemi toimii tuli selväksi
