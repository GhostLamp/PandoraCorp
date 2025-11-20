extends Area2D
class_name Explosion

@onready var collision = $CollisionShape2D
@export var damage = 0
var player_made = true
var mouse
var kills:int = 0



func _on_body_entered(body):
	if player_made:
		if body.has_method("handle_hit"):
			var direction = body.position - position
			var attack = Attack.new()
			attack.damage = damage
			attack.direction = direction
			body.handle_hit(attack)
	else:
		if body.has_method("handle_damage"):
			body.handle_damage()
	
	if body.has_method("jump"):
		var _direction = (body.position - position).normalized()
		var Yvel = -2000
		body.jump(Yvel)



func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
