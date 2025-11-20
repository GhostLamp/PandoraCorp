extends Node2D
class_name Room

@onready var interact_map: TileMapLayer = $interact_map
@onready var tiles: TileMapLayer = $tiles
@onready var navigation_tiles: TileMapLayer = $navigationTiles
@onready var enemy_navegation: TileMapLayer = $enemy_navegation
@onready var effect_layer: TileMapLayer = $effect_layer


@export var cell_pos:Vector2 = Vector2(1,4)
@export var camera_lock: CameraLock 
@export var enemy_manager: EnemyManeger 
@export var minigame:Minigame
@export var waves:int = 2

var chest:PackedScene = preload("res://objects/chest.tscn")
var battleReady:bool = true
var batteling = false
var active = false
var blocker:Array

func _ready() -> void:
	fade_out()

func fade_in():
	var tween = get_tree().create_tween()
	
	tween.tween_property(self,"modulate",Color.WHITE,0.5)
	
	if blocker:
		get_tree().current_scene.minimap_layer.showMap(blocker,cell_pos)
		blocker = []

func fade_out():
	var tween = get_tree().create_tween()
	
	tween.tween_property(self,"modulate",Color.TRANSPARENT,0.5)


func getDoors():
	for child in get_children():
		if child.name == "door_indicator":
			get_tree().current_scene.roomIndicators.append(child)
			child.modulate = Color8(225,225,225,100)
			child.z_index = -4

func setNavigation():
	active = true
	var navtiles = navigation_tiles.get_used_cells()
	
	for i in navtiles:
		enemy_navegation.set_cell(i,1,Vector2(3,3))
		effect_layer.set_cell(i,1,Vector2(3,4))

func end_navigation():
	active = false
	for i in enemy_navegation.get_used_cells():
		enemy_navegation.erase_cell(i)
		effect_layer.erase_cell(i)

func startRoom():
	if enemy_manager.budget <=0:
		return
	if waves <=0:
		return
	batteling = true
	if battleReady:
		waves -= 1
		enemy_manager.startFight($navigationTiles.get_used_cells())
		battleReady = false
		lock_room()
	

func lock_room():
	for door in get_tree().current_scene.doorScenes:
		door.lock()
	for i in get_tree().current_scene.roomIndicators:
		i.visible = false

func end_wave():
	if waves > 0:
		battleReady = true
		startRoom()
		return
	open_room()

func open_room():
	for door in get_tree().current_scene.doorScenes:
		door.unlock()
	for i in get_tree().current_scene.roomIndicators:
		i.visible = true
	
	if batteling:
		spawn_chest()

	batteling = false

func spawn_chest():
	var new_chest:Chest = chest.instantiate()
	var player:Player = get_tree().current_scene.player
	get_tree().current_scene.call_deferred("add_child",new_chest)
	var valid_position = false
	while !valid_position:
		new_chest.position = player.camera_2d.get_screen_center_position() + Vector2(randf_range(-200,200),randf_range(-200,200))
		
		var pos = navigation_tiles.to_local(new_chest.global_position)
		var chest_tile_position = navigation_tiles.local_to_map(pos)
		var data: TileData = navigation_tiles.get_cell_tile_data(chest_tile_position)
		if data:
			valid_position = true

func overtime_spawning():
	if batteling:
		return
	if minigame:
		return
	enemy_manager.Overtime_extra($navigationTiles.get_used_cells())


func end_room():
	enemy_manager.end_room()

func overtime():
	if minigame:
		return
	enemy_manager.budget = enemy_manager.overtime_budget
	enemy_manager.startFight($navigationTiles.get_used_cells())
