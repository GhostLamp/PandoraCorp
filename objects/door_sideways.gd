extends StaticBody2D
class_name Door

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var sidaways := false

var isLocked = false
var isOpen = false



func unlock():
	isLocked = false
	if sidaways:
		animation_player.play("open_side")
		return
	animation_player.play("open_upward")

func open():
	if isLocked:
		return
	
	isOpen = true
	if sidaways:
		animation_player.play("opening_side")
		return
	animation_player.play("opening_upward")

func lock():
	isLocked = true
	if isOpen:
		if sidaways:
			animation_player.play("closing_side")
			return
		animation_player.play("closing_upward")
		
		return
	
	isOpen = false
	if sidaways:
		animation_player.play("closed_side")
		return
	animation_player.play("closed_upward")


func handle_hit(_attack:Attack):
	open()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CollisionObject2D:
		return
	get_tree().current_scene.doorScenes.erase(self)
	queue_free()
