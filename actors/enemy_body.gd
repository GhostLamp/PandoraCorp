class_name EnemyBody
extends CharacterBody2D


func _physics_process(_delta):
	move_and_slide()

func handle_hit(attack: Attack):
	get_parent().handle_hit(attack)
