extends Sprite2D

func _physics_process(delta): #Simple just points at mouse
	look_at(get_global_mouse_position())
	
