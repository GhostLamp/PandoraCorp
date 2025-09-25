extends CharacterBody2D

func _physics_process(_delta):
	move_and_slide()

func handle_damage():
	get_parent().damaged()
