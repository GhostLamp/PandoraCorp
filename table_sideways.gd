extends interactive



@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.interaction.append(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.interaction.erase(self)


func interact(player:Player):
	await player.interact()
	if player.global_position.y > self.global_position.y:
		animation_player.play("flip_up")
	else:
		animation_player.play("flip_down")
			
