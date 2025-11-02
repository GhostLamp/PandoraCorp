class_name Explosive
extends Node2D


@export var status_type = 4
@export var explosion : PackedScene
@export var explosion_damage = 2
var insta_exosion:bool = false
var hit_stop:bool = false


func on_hit(collider):
	if collider.has_node("health"):
		
		if collider.health_stat.health > get_parent().get_parent().damage and !insta_exosion:
			return
		
		var new_explosion = explosion.instantiate()
		new_explosion.position = collider.global_position
		new_explosion.damage = explosion_damage
		get_tree().root.call_deferred("add_child", new_explosion)
		
		if hit_stop:
			HitstopManeger.hitstop_weak()
			HitstopEfect.hitstop_efect_short()
