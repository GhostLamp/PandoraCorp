extends Node
class_name State

@export var stateName:String
var parent:Enemy

func _ready() -> void:
	parent = get_parent().get_parent()


func state_process(delta:float):
	pass

func swapState(newStateName:String):
	get_parent().set_state(newStateName)
