extends BaseActiveStrat

@export var vel = -2000
@onready var special_cooldown: Timer = $special_cooldown
@export var Pickup:PackedScene


func special_activation():
	var player:Player = get_parent().get_parent().get_parent()
	player.jump(vel)

func swap_out():
	var new_pickup = Pickup.instantiate()
	get_tree().root.call_deferred("add_child",new_pickup)
