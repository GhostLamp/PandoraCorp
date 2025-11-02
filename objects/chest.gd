extends RigidBody2D
class_name Chest


@onready var status_manager: Node2D = $status_manager
@export var chestProbabillity:Array[ChestLoot] = []
@onready var sprite_2d: Sprite2D = $Sprite2D


var opened = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	return
	if body is Player:
		body.interaction.append(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	return
	if body is Player:
		body.interaction.erase(self)


func interact(player: Player):
	if !opened:
		opened = true
		await player.interact()
		var rand = randi()%100
		var lowest_chance = 200
		var result:ChestLoot
		
		for i in chestProbabillity:
			if i.chance >= rand:
				if i.chance <= lowest_chance:
					lowest_chance = i.chance
					result = i
		
		result.lootSpawn(self)
		sprite_2d.frame = 1


func handle_hit(_attack:Attack):
	var player:Player = get_tree().current_scene.player
	interact(player)
