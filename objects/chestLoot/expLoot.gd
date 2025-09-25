extends ChestLoot
class_name expLoot

@export var fuel: PackedScene
@export var amount:int

func lootSpawn(chest:Chest):
	for i in amount:
		var new_fuel:ExpOrb = fuel.instantiate()
		new_fuel.position = chest.global_position + Vector2(randf_range(-64,64),randf_range(-64,64))
		new_fuel.direction = (new_fuel.global_position - chest.global_position).normalized()
		var enemy_maneger:EnemyManeger = chest.get_tree().current_scene.player.currentRoom.enemy_manager
		enemy_maneger.fuel_orbs.append(new_fuel)
		chest.get_tree().current_scene.call_deferred("add_child", new_fuel)
