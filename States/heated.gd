extends Node2D

@export var burning :PackedScene = preload("res://States/burning.tscn")
@export var status_type = 2
@export var new = true


func on_hit(collider):
	var burn = burning.instantiate()
	if collider.has_node("status_manager"):
		collider.status_manager.call_deferred("add_child", burn)


func _ready() -> void:
	if new == true:
		get_parent().get_parent().modulate = modulate
