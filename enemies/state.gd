extends Node
class_name State

@export var stateName:String
var parent:Enemy
var player:Player

func _ready() -> void:
	if get_parent().get_parent() is Enemy:
		parent = get_parent().get_parent()
		return
	
	player = get_parent().get_parent()


func state_process(_delta:float):
	pass

func state_enter():
	pass

func swapState(newStateName:String):
	get_parent().set_state(newStateName)
