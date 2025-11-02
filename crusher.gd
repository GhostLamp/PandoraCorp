extends CharacterBody2D
class_name Crusher

signal crushed

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var box:PackedScene
@export var tall_box:PackedScene
@export var crush_speed:float = 1
@export var pack:bool = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		crush()


func crush():
	if animation_player.current_animation:
		return
	
	animation_player.speed_scale = crush_speed
	animation_player.play("crush")
	await get_tree().create_timer(1).timeout
	velocity = Vector2(0,0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Box:
		return
	
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 100
		attack.style_modifiers.append("crushed")
		body.handle_hit(attack)
		if pack:
			var new_box = box.instantiate()
			new_box.global_position = body.global_position 
			get_tree().current_scene.call_deferred("add_child",new_box)
	
	if body is Player:
		body.damaged(15)
		
		if pack:
			body.player_state_machine.set_state("stunned")
			var new_box:Box = tall_box.instantiate()
			get_tree().current_scene.call_deferred("add_child",new_box)
			new_box.global_position = body.global_position + Vector2(0,60)
			new_box.player = body
	
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "crush":
		await get_tree().create_timer(0.2).timeout
		animation_player.play("rell_back")
