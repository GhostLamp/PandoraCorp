extends State
class_name StateMachine

@export var floaty:bool = false

var current_state:State
var states:Array[State]

func _ready() -> void:
	if get_parent()is Enemy:
		parent = get_parent()
	else:
		player = get_parent()
	
	for child in get_children():
		if child is State:
			states.append(child)
	
	current_state = states[0]

func state_process(delta:float):
	if parent.Yvel < 0 and not floaty:
		set_state("airborn")
	current_state.state_process(delta)

func state_physics_process(delta:float):
	current_state.state_physics_process(delta)

func set_state(newStateName):
	if newStateName == current_state.stateName:
		return
	for i in states.size():
		if states[i].stateName == newStateName:
			current_state = states[i]
	
	current_state.state_enter()
