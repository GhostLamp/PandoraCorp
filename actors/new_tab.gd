extends BaseActiveStrat

@export var wallbouncer : PackedScene
@onready var barrel_origin: Marker2D = $Node2D/Marker2D
@export var special_cooldown: Timer 




func  special_activation():
	special_cooldown.start()
	
	var mouse = get_global_mouse_position() - global_position
	await get_tree().create_timer(0.5).timeout
	var new_wallbouncer = wallbouncer.instantiate()
	new_wallbouncer.position = barrel_origin.global_position if barrel_origin else global_position
	new_wallbouncer.damage = 10
	new_wallbouncer.direction = mouse.normalized()
	get_tree().root.call_deferred("add_child", new_wallbouncer)
