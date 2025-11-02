class_name BaseItemStrat
extends Resource

@export var texture: Texture = preload("res://items_sprite.png")
@export var scene: PackedScene
@export var item_region:Rect2
@export var name:String
@export var activation:String
@export_multiline var descripition:String



func apply_boost(_player : Player):
	pass

func weapon_boost(_weapon):
	pass

func bullet_boost(_bullet: Bullet):
	pass

func on_hit(_enemy):
	pass

func on_player_damaged(_player:Player):
	pass

func on_reload(_player:Player,_ammo,_max_ammo):
	pass
