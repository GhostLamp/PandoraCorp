extends Node
class_name FuelCounter
@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var progress_bar_2: TextureProgressBar = $ProgressBar2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

@export var node_2d: Node2D 

@export var dungeon_fuel:float = 100
var maxFuel:float = 100
var mimFuel:float = 0
var times_filled = 0
var fuel:float = 0
var timeToSpawn = 1
var spawn_position

func set_fuel(new_fuel:float):
	fuel = new_fuel
	progress_bar.max_value = maxFuel
	progress_bar_2.max_value = maxFuel
	progress_bar_2.min_value = mimFuel
	node_2d.look_at(Vector2(0,0))
	if fuel >= maxFuel:
		times_filled += 1
		mimFuel = maxFuel 
		maxFuel += dungeon_fuel
		progress_bar_2
		AudioGlobal.low_time_left = "LowTime"
		node_2d.visible = true
		
		if times_filled > 1:
			label.visible = true
			label.text = "x" + str(times_filled)
		
		if animation_player.current_animation:
			return
		animation_player.play("fuelFull")

func _process(delta: float) -> void:
	progress_bar.value = move_toward(progress_bar.value,fuel,delta*100)
	progress_bar_2.value = move_toward(progress_bar_2.value,fuel,delta*100)
	
	
	
	if !spawn_position:
		spawn_position = node_2d.global_position
	
	node_2d.look_at(spawn_position)
	if fuel < dungeon_fuel:
		return
	
	if timeToSpawn > 0:
		timeToSpawn -= delta
		return
	
	timeToSpawn = 1
	get_parent().get_parent().get_parent().currentRoom.overtime_spawning()
	
