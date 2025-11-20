extends BaseItemStrat
class_name PoleArm

@export var sprite:Texture2D
@export var frame_size:Vector2

func on_dash_hit(player:Player):
	player.jump(-2000)
	var pole:Sprite2D = scene.instantiate()
	pole.texture = sprite
	pole.hframes = frame_size.x
	pole.vframes = frame_size.y
	player.get_tree().current_scene.call_deferred("add_child",pole)
	pole.global_position = player.global_position
	await player.get_tree().create_timer(0.0625*17).timeout
	pole.queue_free()
	return
