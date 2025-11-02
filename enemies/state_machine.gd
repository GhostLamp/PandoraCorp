extends State
class_name StateMachine

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
	if parent.Yvel < 0:
		set_state("airborn")
	current_state.state_process(delta)

func set_state(newStateName):
	for i in states.size():
		if states[i].stateName == newStateName:
			current_state = states[i]
