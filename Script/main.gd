extends Node2D
class_name main


#This script is poorly named but this handles basicly start of game
var root_node: Branch
var tilemap:TileMap
var tile_size: int = 16
var paths: Array = []
var cells: Array = []
var Room_AutoMap = []
var Random_Tile = []
var Can_Place_Over_These = "can_place"
@onready var Player = $Kunoichi
@onready var bullet_manager = $BulletManager
@onready var enemy_manager = $EnemyManager

#Tässä piirämme lehdet
func _ready():
	Player.player_fired_bullet.connect(bullet_manager.handle_bullet_spawned)
	tilemap = get_node("TileMap")
	root_node  = Branch.new(Vector2i(0, 0), Vector2i(120, 60)) #60 leveä ja 30 pitkä
	root_node.split(3, paths)
	queue_redraw()
	pass

func _draw():
	var rng = RandomNumberGenerator.new()
	for leaf in root_node.get_leaves():
		var padding = Vector4i(
			rng.randi_range(1,3),
			rng.randi_range(1,3),
			rng.randi_range(1,3),
			rng.randi_range(1,3)
			)
		var padding2 = Vector4i(0,0,0,0)
		
		for x in range(leaf.size.x):
			for y in range(leaf.size.y):
				if not is_outside_padding(x, y, leaf, padding):
					tilemap.set_cell(0, Vector2i(x + leaf.position.x  +1,y + leaf.position.y +1) , 0, Vector2i(17, 8))
					Room_AutoMap.append(Vector2i(x + leaf.position.x  +1,y + leaf.position.y +1))
				if not is_inside_padding(x, y, leaf, padding):
					tilemap.set_cell(0, Vector2i(x + leaf.position.x,y + leaf.position.y), 0, Vector2i(17, 13))
					draw_rect(
			Rect2(
				leaf.position.x * tile_size, # x
				leaf.position.y * tile_size, # y
				leaf.size.x * tile_size, # width/leveys
				leaf.size.y * tile_size # height/korkeus
			), 
			Color.REBECCA_PURPLE, # colour/väri reunille
			false # is filled - täytetty
			)
	for path in paths:
		if path["left"].y == path["right"].y:
			#horizontal
				for i in range(path["right"].x - path["left"].x):
					#figuroi parempi tapa esim patternit käytävän seinille
					tilemap.set_cell(0, Vector2i(path["left"].x+i,path["left"].y -1), 0, Vector2i(17, 12)) #seinä
					tilemap.set_cell(0, Vector2i(path["left"].x+i,path["left"].y +1), 0, Vector2i(16, 14)) #ala seinä
					tilemap.set_cell(0, Vector2i(path["left"].x+i,path["left"].y), 0, Vector2i(17, 13))
					Room_AutoMap.append(Vector2i(path["left"].x+i,path["left"].y -1))
					Room_AutoMap.append(Vector2i(path["left"].x+i,path["left"].y +1))
					Room_AutoMap.append(Vector2i(path["left"].x+i,path["left"].y))
		else:
		 	# vertical
				for i in range(path['right'].y - path['left'].y):
					tilemap.set_cell(0, Vector2i(path['left'].x -1,path['left'].y+i), 0, Vector2i(15, 13)) #vasen seinä
					tilemap.set_cell(0, Vector2i(path['left'].x +1,path['left'].y+i), 0, Vector2i(20, 13)) #oikea seinä
					tilemap.set_cell(0, Vector2i(path['left'].x,path['left'].y+i), 0, Vector2i(17, 13))
					Room_AutoMap.append(Vector2i(path['left'].x -1,path['left'].y+i))
					Room_AutoMap.append(Vector2i(path['left'].x +1,path['left'].y+i))
					Room_AutoMap.append(Vector2i(path['left'].x,path['left'].y+i))
		tilemap.set_cells_terrain_connect(0, Room_AutoMap, 0,0)
		#Sijoitetaan pelaaja tileen
		place_on_tile(Player)
		place_array_on_tile(enemy_manager.get_children())
	pass

#Functioon handlaamaan random sijoittaminen, jotta voidaan mahdollisesti hyödyntää vihollisille.
func place_on_tile(object):
	Random_Tile += tilemap.get_used_cells_by_id(0, 0, Vector2i(17, 13)) #hae kaikki lattia tilet
	var random_pos = Vector2i(Random_Tile.pick_random()) * 16 
	object.position = random_pos #sijoita random tileen objekti
	pass
	
func place_array_on_tile(array):
	Random_Tile += tilemap.get_used_cells_by_id(0, 0, Vector2i(17, 13)) #hae kaikki lattia tilet
	for i in array:
		var random_pos = Vector2i(Random_Tile.pick_random()) * 16 
		i.position = random_pos #sijoita random tileen objekti arraysta
	pass

func is_inside_padding(x, y, leaf, padding):
	return x <= padding.x +2 or y <= padding.y +2 or x >= leaf.size.x - padding.z or y >= leaf.size.y - padding.w
func is_outside_padding(x, y, leaf, padding):
	return x <= padding.x or y <= padding.y or x >= leaf.size.x - padding.z or y >= leaf.size.y - padding.w
	
