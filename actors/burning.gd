extends Node2D

@export var status_type = 1

func _on_timer_timeout() -> void:
	var attack = Attack.new()
	attack.damage = 1
	get_parent().get_parent().handle_hit(attack)
	


func _on_child_entered_tree(_node: Node) -> void:
	get_parent().get_parent().modulate = modulate
