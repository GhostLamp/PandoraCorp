extends BaseActiveStrat

@export var barrel_origin: Marker2D
@export var parry_force : int
@onready var parry = $parry
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var gunsprite = $Sprite2D
@export var special_cooldown: Timer 


var bullet_direction

func _ready() -> void:
	parry.parry_hit.connect(parry_hit)


func special_activation():
	parry_force = 2
	var mouse = get_global_mouse_position()
	special_cooldown.start()
	visible = true
	look_at(mouse)
	bullet_direction = (barrel_origin.global_position - global_position).normalized()
	if mouse < global_position:
		gunsprite.flip_v = true
	if mouse > global_position :
		gunsprite.flip_v = false
	
	anim.play("reboot")



func parry_hit():
	parry_force = 1
	
	anim.play("on_hit")





func _on_melee_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 2
		attack.direction = bullet_direction
		attack.soft = true
		area.handle_hit(attack)


func _on_melee_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		var attack = Attack.new()
		attack.damage = 2
		attack.direction = bullet_direction
		attack.soft = true
		body.handle_hit(attack)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	visible = false
