extends Node2D
class_name Minigame

@export var crusher:ControlableCrusher


@export var label: Label 
@export var controls:Label
@export var chest:PackedScene

var active:bool = false
var spawns_left = 15
var kill_time = 3
var spawns:Array[Enemy] = []
var time:float = 10
var time_to_spawn = 0
var kills = 0
var room:Room 


func _ready() -> void:
	room = get_parent()
	for child in get_children():
		if child is Door:
			get_tree().current_scene.doorScenes.append(child)
			child.lock()

func minigame_start():
	room.enemy_manager.budget = spawns_left
	room.startRoom()
	room.enemy_manager.budget = 0
	active = true
	label.visible = true
	controls.modulate = Color.WHITE
	await get_tree().create_timer(2).timeout
	var tween = get_tree().create_tween()
	
	tween.tween_property(controls,"modulate",Color.TRANSPARENT,1)

func minigame_end():
	active = false
	crusher.end(get_tree().current_scene.player)
	label.visible = false
	for door in get_tree().current_scene.doorScenes:
		door.unlock()
	if kills > -1:
		room.chest = chest
	room.spawn_chest()


func _process(delta: float) -> void:
	if !active:
		return
	
	
	
	if time > 0 and spawns.size() > 0:
		time-=delta
		label.text = str(ceil(time))
		return
	
	
	
	var attack = Attack.new()
	attack.damage = 0.01
	for i in spawns:
		i.handle_hit(attack)
	active = false
	await get_tree().create_timer(0.1).timeout
	minigame_end()
	room.end_room()
	spawns.clear()
	
