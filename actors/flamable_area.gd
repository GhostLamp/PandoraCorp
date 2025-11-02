extends Area2D

@export var burning :PackedScene
var used:bool = false

func on_fire():
	var burn = burning.instantiate()
	get_parent().status_manager.new_effect(burn)


func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	on_fire()
	if !used:
		used = true
		body._on_timer_timeout()
