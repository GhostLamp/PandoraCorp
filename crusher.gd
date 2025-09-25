extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if animation_player.current_animation:
			return
		
		animation_player.play("crush")





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 100
		body.handle_hit(attack)
		get_tree().current_scene.player.stylish("crushed")
	
	if body is Player:
		body.damaged()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "crush":
		animation_player.play("rell_back")
