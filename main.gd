extends Node2D

@onready var button: AnimationPlayer = $button
var charsel = load("res://actors/character_select.tscn")


func _on_button_2_pressed():
	get_tree().quit()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://actors/character_select.tscn")


func buttonEntered():
	button.play("buttonEnter")

func buttonLeft():
	button.play("buttonLeave")
