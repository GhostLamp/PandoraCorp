extends CharacterBody2D
class_name Box

@onready var status_manager: Node2D = $status_manager

var player:Player
var shake_intensity:int = 0

func _process(_delta: float) -> void:
	if player:
		$Sprite2D.position = Vector2(0,-56) +Vector2(randf_range(-2,2),randf_range(-2,2))*shake_intensity
		if player.player_state_machine.current_state.stateName != "stunned":
			queue_free()
		if Input.is_action_just_pressed("ui_accept"):
			shake_intensity+=1
	check_tile()
	move_and_slide()

func check_tile():
	var pos = get_tree().current_scene.player.currentRoom.tiles.to_local($CollisionShape2D2.global_position)
	var coords = get_tree().current_scene.player.currentRoom.tiles.local_to_map(pos)
	var data: TileData = get_tree().current_scene.player.currentRoom.tiles.get_cell_tile_data(coords)
	
	if !data:
		set_process(false)
		return
	
	if data.get_custom_data("moving"):
		set_process(true)
		velocity = data.get_custom_data("moving") * 800
	else:
		set_process(false)
		velocity = Vector2(0,0)


func handle_hit(_attack:Attack):
	var player:Player = get_tree().current_scene.player
	var pos = player.currentRoom.enemy_navegation.to_local(global_position)
	var coords = player.currentRoom.enemy_navegation.local_to_map(pos)
	
	player.currentRoom.enemy_navegation.set_cell(coords,1,Vector2(3,3))
	queue_free()
