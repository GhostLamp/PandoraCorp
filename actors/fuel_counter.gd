extends Node
class_name FuelCounter
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var progress_bar_2: ProgressBar = $ProgressBar2
@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@export var node_2d: Node2D 

@export var maxFuel:float = 100
var fuel:float = 0
var timeToSpawn = 1
var spawn_position

func set_fuel(new_fuel:float,new_max:float):
	fuel = new_fuel
	maxFuel = new_max
	progress_bar.max_value = maxFuel
	progress_bar_2.max_value = maxFuel
	node_2d.look_at(Vector2(0,0))
	if fuel >= maxFuel:
		AudioGlobal.low_time_left = "LowTime"
		label.visible = true
		label_2.visible = true
		node_2d.visible = true


func _process(delta: float) -> void:
	progress_bar.value = move_toward(progress_bar.value,fuel,delta*100)
	progress_bar_2.value = move_toward(progress_bar_2.value,fuel,delta*100)
	if !spawn_position:
		spawn_position = node_2d.global_position
	
	node_2d.look_at(spawn_position)
	if fuel < maxFuel:
		return
	
	if timeToSpawn > 0:
		timeToSpawn -= delta
		return
	
	timeToSpawn = 1
	get_parent().get_parent().get_parent().currentRoom.overtime_spawning()
	
