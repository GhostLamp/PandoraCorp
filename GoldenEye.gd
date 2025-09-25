extends BaseActiveStrat

@export var weapon : PackedScene
@export var special_cooldown: Timer 
@export var effect:PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D

func  special_activation():
	special_cooldown.start()
	
	var bruh:SingleUseWeapon = weapon.instantiate()
	
	bruh.texture = sprite_2d.texture
	bruh.texture_region = sprite_2d.region_rect
	
	bruh.await_time = 0.0
	bruh.quick = true
	
	bruh.effect = effect
	
	get_tree().current_scene.player.gun_maneger.call_deferred("add_child", bruh)
