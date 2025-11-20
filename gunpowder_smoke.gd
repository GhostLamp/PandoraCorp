extends Node2D

var used = false
@export var explosion:PackedScene
func _on_area_entered(area: Area2D) -> void:
	if area is Explosion:
		explode()

func explode():
	if used:
		return
	used = true
	await get_tree().create_timer(0.1).timeout
	var new_explosion = explosion.instantiate()
	new_explosion.position = global_position
	new_explosion.damage = 2
	get_tree().current_scene.call_deferred("add_child", new_explosion)
	queue_free()

func add_effect(effect):
	explode()
