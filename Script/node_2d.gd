extends Node2D

var root_node: Branch
var tilemap:TileMap
var tile_size: int = 16
var paths: Array = []
var cells: Array = []




#Tässä piirämme lehdet
func _ready():
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
				if not is_inside_padding(x, y, leaf, padding):
					tilemap.set_cell(1, Vector2i(x + leaf.position.x,y + leaf.position.y), 0, Vector2i(9, 12))
					draw_rect(
			Rect2(
				leaf.position.x * tile_size, # x
				leaf.position.y * tile_size, # y
				leaf.size.x * tile_size, # width/leveys
				leaf.size.y * tile_size # height/korkeus
			), 
			Color.REBECCA_PURPLE, # colour/väri reunille
			true # is filled - täytetty
			)
	for path in paths:
		if path["left"].y == path["right"].y:
			#horizontal
				for i in range(path["right"].x - path["left"].x):
					#figuroi parempi tapa esim patternit käytävän seinille
					tilemap.set_cell(0, Vector2i(path["left"].x+i,path["left"].y -2), 0, Vector2i(17, 11)) #ylä seinä
					tilemap.set_cell(0, Vector2i(path["left"].x+i,path["left"].y -1), 0, Vector2i(17, 12)) #ylä seinä
					tilemap.set_cell(0, Vector2i(path["left"].x+i,path["left"].y +1), 0, Vector2i(16, 14)) # ala seinä
					tilemap.set_cell(1, Vector2i(path["left"].x+i,path["left"].y), 0, Vector2i(9, 12))
		else:
		 	# vertical
				for i in range(path['right'].y - path['left'].y):
					tilemap.set_cell(0, Vector2i(path['left'].x -1,path['left'].y+i), 0, Vector2i(15, 13)) #vasen seinä
					tilemap.set_cell(0, Vector2i(path['left'].x +1,path['left'].y+i), 0, Vector2i(20, 13)) #oikea seinä
					tilemap.set_cell(1, Vector2i(path['left'].x,path['left'].y+i), 0, Vector2i(9, 12))
	pass

func is_inside_padding(x, y, leaf, padding):
	return x <= padding.x +2 or y <= padding.y +2 or x >= leaf.size.x - padding.z or y >= leaf.size.y - padding.w
func is_outside_padding(x, y, leaf, padding):
	return x <= padding.x or y <= padding.y or x >= leaf.size.x - padding.z or y >= leaf.size.y - padding.w
	

