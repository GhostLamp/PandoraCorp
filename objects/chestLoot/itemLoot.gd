extends ChestLoot
class_name ItemLoot

@export var reward:Array [BaseItemStrat]
var item_holder = preload("res://Items/item_pickup.tscn")

func lootSpawn(_chest:Chest):
	var new_item:ItemPickUp = item_holder.instantiate()
	new_item.item = reward.pick_random()
	new_item.position = _chest.global_position
	_chest.get_tree().root.call_deferred("add_child", new_item)
