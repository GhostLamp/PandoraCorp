extends Node2D
class_name Room

@onready var interact_map: TileMapLayer = $interact_map
@onready var tiles: TileMapLayer = $tiles
@onready var navigation_tiles: TileMapLayer = $navigationTiles



@export var camera_lock: CameraLock 
@export var enemy_manager: EnemyManeger 


var chest:PackedScene = preload("res://objects/chest.tscn")
var battleReady:bool = true
var batteling = false


func getDoors():
	for child in get_children():
		if child is Door:
			get_tree().current_scene.doorScenes.append(child)
			child.unlock()

func startRoom():
	batteling = true
	if enemy_manager.budget <=0:
		return
	
	if battleReady:
		enemy_manager.startFight($navigationTiles.get_used_cells())
		battleReady = false
		lock_room()

func lock_room():
	for door in get_tree().current_scene.doorScenes:
		door.lock()

func open_room():
	for door in get_tree().current_scene.doorScenes:
		door.unlock()
	
	if batteling:
		var new_chest = chest.instantiate()
		var player:Player = get_tree().current_scene.player
		get_tree().current_scene.call_deferred("add_child",new_chest)
		new_chest.position = player.camera_2d.get_screen_center_position() + Vector2(randf_range(-200,200),randf_range(-200,200))

	batteling = false

func overtime_spawning():
	if !batteling:
		enemy_manager.Overtime_extra($navigationTiles.get_used_cells())


func end_room():
	enemy_manager.end_room()

func overtime():
	enemy_manager.budget = enemy_manager.overtime_budget
	enemy_manager.startFight($navigationTiles.get_used_cells())
