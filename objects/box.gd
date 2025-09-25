extends StaticBody2D
class_name Box

@onready var status_manager: Node2D = $status_manager



func handle_hit(_attack:Attack):
	queue_free()
