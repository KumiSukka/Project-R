extends Node
#Tässä osiossa kehitetään matikka algorytmille eli oksien ja lehtien koot ja niin edelleen ei pitäis tarvita säätää tästä enää oikein mitään
class_name Branch

var left_child: Branch
var right_child: Branch
var position: Vector2
var size: Vector2i


func _init(position, size):
	self.position = position
	self.size = size
	
func get_leaves():
	if not(left_child && right_child):
		return [self]
	else:
		return left_child.get_leaves() + right_child.get_leaves()

func get_center():
	return Vector2i(position.x + size.x /2, position.y + size.y/2)

func split(remaining, paths):
	var rng = RandomNumberGenerator.new()
	var split_percent = rng.randf_range(0.40,0.60) #Oksien katkaisut tulee olemaan 30%-70%
	var split_horizontal = size.y >= size.x #tarkastetaan että ei ole korkeampi kuin leveä

	if(split_horizontal):
		#horizontal - vaakasuora
		var left_height = int(size.y * split_percent)
		left_child = Branch.new(position, Vector2i(size.x, left_height))
		right_child = Branch.new(
			Vector2i(position.x, position.y + left_height),
			Vector2i(size.x, size.y - left_height)
		)
	else:
		#Vertical - Pystysuora
		var left_width = int(size.x * split_percent)
		left_child = Branch.new(position, Vector2i(left_width, size.y))
		right_child = Branch.new(
			Vector2i(position.x + left_width, position.y),
			Vector2i(size.x - left_width, size.y)
		)
	if(remaining > 0):
		left_child.split(remaining - 1, paths)
		right_child.split(remaining - 1, paths)
	paths.push_back({'left': left_child.get_center(), 'right': right_child.get_center()})
	pass
# We are trying to keep everything as ints, this is so that it makes it easier to swap out each 1x1 for a tile in our tilemap later.
# We recursively split cells until remaining is zero. This means we only have to call split(5) on the root node, and it will give us 32 rooms.


	#https://jonoshields.com/post/bsp-dungeon Tämän hienon dugemention bsp dungeonista mukaan täystetty systeemin pohja, koska kävi läpi godotissa ja myöskin miten mapata autotilet, jonka kanssa minulla on suuresti ollut ongelmia
