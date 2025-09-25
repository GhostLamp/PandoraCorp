class_name BaseActiveStrat
extends Node2D

@export var adrenaline_cost:float = 0
@export var texture: Texture = preload("res://items_sprite.png")
@export var item_region:Rect2


func get_adrenaline_cost():
	return adrenaline_cost

func special_activation():
	pass
func finish():
	pass
