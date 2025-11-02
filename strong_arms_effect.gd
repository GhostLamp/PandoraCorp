extends BaseActiveStrat

@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var special_cooldown: Timer 
@export var trown_projectile:PackedScene
@export var held_projecile:PackedScene


var enemy_held:Array[HeldEnemy] = []

func get_adrenaline_cost():
	var player:Player = get_tree().current_scene.player
	
	if player.gun_maneger.weapons.size() >3:
		return 0
	
	if enemy_held.size() > 0:
		return 0
	
	return adrenaline_cost

func  special_activation():
	look_at(get_global_mouse_position())
	var player:Player = get_tree().current_scene.player
	special_cooldown.start()
	
	if player.gun_maneger.weapons.size() >3:
		return
	
	if enemy_held.size() > 0:
		if is_instance_valid(enemy_held[0]):
			pass
		else:
			enemy_held.clear()

	
	if enemy_held.size() > 0:
		player.gun_maneger.current_weapon.shoot()
	else:
		animation_player.play("grapple")

func _on_melee_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if enemy_held.size() > 0:
			return
		
		var new_held:HeldEnemy = held_projecile.instantiate()
		new_held.enemy = body
		enemy_held.append(new_held)
		get_tree().current_scene.player.gun_maneger.call_deferred("add_child", new_held)


	

func finish():
	if enemy_held.size() > 0:
		if is_instance_valid(enemy_held[0]):
			enemy_held[0].queue_free()
			enemy_held.clear()
		else:
			enemy_held.clear()
