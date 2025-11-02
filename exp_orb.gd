extends CharacterBody2D
class_name ExpOrb

var player:Player
var direction:Vector2 = Vector2(0,0)
var speed:float = 400
var min_distance:float = 240

func _ready() -> void:
	player = get_tree().current_scene.player

func _process(delta: float) -> void:
	if global_position.distance_to(player.global_position) < min_distance:
		direction = (player.global_position - global_position).normalized()
		speed = 1200
	else:
		speed = move_toward(speed,0,delta*1200)
	velocity = speed * direction
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.gainFuel()
		var enemy_maneger:EnemyManeger = get_tree().current_scene.player.currentRoom.enemy_manager
		enemy_maneger.fuel_orbs.erase(self)
		queue_free()


func check_tile():
	var pos = get_tree().current_scene.player.currentRoom.tiles.to_local(global_position)
	var coords = get_tree().current_scene.player.currentRoom.tiles.local_to_map(pos)
	var data: TileData = get_tree().current_scene.player.currentRoom.tiles.get_cell_tile_data(coords)
	
	if !data:
		min_distance = 10000
		return
	
	if data.get_custom_data("unsafe"):
		min_distance = 10000
		


func _on_timer_timeout() -> void:
	check_tile()
