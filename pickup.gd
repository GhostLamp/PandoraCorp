extends interactive

@export var weapon : PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.interaction.append(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	hideFKey()
	if body is Player:
		body.interaction.erase(self)


func interact(player:Player):
	await player.interact()
	if player.gun_maneger.weapons.size() >3:
		return
	var bruh:SingleUseWeapon = weapon.instantiate()
	bruh.basic_shot_damage = 4
	
	bruh.texture = sprite_2d.texture
	
	bruh.texture_region = sprite_2d.region_rect
	
	bruh.bullet_sprite = sprite_2d.texture
	
	bruh.bullet_region = sprite_2d.region_rect
	
	player.gun_maneger.call_deferred("add_child", bruh)
	queue_free()
