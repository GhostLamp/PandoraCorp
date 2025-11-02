extends interactive
class_name ControlableCrusher


@export var crusher:Crusher
@export var navegation_deleter:Area2D

var active:bool = false
var direction 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !interactable:
		return
	if body is Player:
		body.interaction.append(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	hideFKey()
	if interactable:
		return
	if body is Player:
		body.interaction.erase(self)


func interact(player: Player):
	if active:
		return
	navegation_deleter.monitoring = true
	player.player_state_machine.force_swap("controlling")
	player.camera_manager.target = crusher
	active = true
	get_parent().minigame_start()

func end(player: Player):
	navegation_deleter.monitoring = false
	player.player_state_machine.force_swap("grounded")
	player.camera_manager.target = player
	interactable = false
	active = false

func _process(delta: float) -> void:
	if !active:
		return
	
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		crusher.velocity = crusher.velocity.move_toward(800*direction , (400)*delta )
	
	
	else:
		crusher.velocity = crusher.velocity.move_toward(Vector2(0,0), 400*delta)
	
	crusher.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if !active:
		return
	
	if  event.is_action_pressed("shoot") or event.is_action_pressed("alt_fire"):
		crusher.crush()
