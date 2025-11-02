extends Enemy


@export var bullet : PackedScene

@export var bullet_count : int
@export_range(0, 360) var arc:float = 0
@export var barrel_origin: Marker2D


@onready var nuzzel_holder: Node2D = $nuzzelHolder
@onready var anim_tree = $body/anim_maneger/AnimationTree
@onready var collision = $CollisionShape2D2
@onready var status_maneger = $status_manager
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var status_manager: Node2D = $status_manager2




func _process(delta):
	collision.position = pos.position
	
	if !spawned:
		return
	check_tile(delta)
	if knock_down.is_stopped():
		state_machine.state_process(delta)
	
	move_and_slide()

func _physics_process(_delta):
	animate()

func flipping():
	var mouse = (next_path_position - global_position).normalized()
	if mouse.x >= 0:
		mouse = Vector2(1,1)
	else:
		mouse = Vector2(-1,1)
	anim.scale = mouse



func animate():
	if state_machine.current_state.stateName == "chasing":
		anim_tree["parameters/conditions/CHASING"] = true
		anim_tree["parameters/conditions/CHARGING"] = false
	if state_machine.current_state.stateName == "charging":
		anim_tree["parameters/conditions/CHASING"] = false
		anim_tree["parameters/conditions/CHARGING"] = true



func _on_navigation_timer_timeout() -> void:
	navigation_agent_2d.target_position = player.position
	next_path_position = navigation_agent_2d.get_next_path_position()
