extends Node2D
class_name Level


@onready var enemy_maneger: Node2D = $enemy_maneger
@onready var minimap_layer: CanvasLayer = $MinimapLayer

var resul = load("res://result_screen.tscn")
var tiles_placed = []
var dungeon_fuel:float = 0
var room_placed = []
var room_size = 1
var doors_positions = []
var free_spots:Array = []


@onready var camera_maneger:CameraManager = $camera_maneger
@export var tile_map:TileMapLayer
@export var player:Player
@export var dungeon:Dungeon
@export var doorScene:PackedScene
var doorScenes:Array[Door]
var roomIndicators:Array[Node2D]



func _ready():
	var new_player = PlayerHolder.player.instantiate()
	new_player.camera_manager = camera_maneger
	new_player.camera_2d = $camera_maneger/Camera2D
	
	call_deferred("add_child",new_player)
	
	player = new_player
	
	
	
	room_size = dungeon.room_radius*2 + 2
	
	for x in dungeon.dungeon_size.x:
		for y in dungeon.dungeon_size.y:
			free_spots.append(Vector2i(x,y)+Vector2i(1,1))
	
	for spot in dungeon.erase_spots:
		free_spots.erase(spot)
	
	
	for i in dungeon.room_types:
		i.position = room_size* tile_fill(i.room_shape)
	
	generate_level()
	player.maxFuel = dungeon_fuel*3/5 
	
	HitstopEfect.swap_to_level_in()
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate",Color.WHITE,1)
	
	player.currentPalette = PlayerHolder.current_palette
	player.paletts = PlayerHolder.paletts
	camera_maneger.target = player


func generate_rooms(start_p, room_type):
	var new_room = RoomCalculator.new(room_type,start_p,room_size,dungeon.room_radius)
	
	var roomMaker = RoomCarver.new(new_room)
	var area_to_carve:CarvedArea = roomMaker.makeRoom()
	
	var rooms = area_to_carve.room
	doors_positions.append_array(area_to_carve.door)
	
	roomMaker.queue_free()
	
	tiles_placed.append_array(rooms)
	
	for location in rooms:
		tile_map.erase_cell(location)
	
	room_placed.append(start_p)
	


func tile_fill(room):
	var searching = true
	var new_position
	var limit = 300
	
	while searching and limit > 0:
		searching = false
		
		if free_spots.size() > 0:
			new_position = free_spots.pick_random()
			
			for x in room.x:
				for y in room.y:
					
					if not free_spots.has(new_position + Vector2i(x,y)):
						searching = true
						limit -= 1
		else:
			limit = 0
	
	if limit > 0:
		for x in room.x:
			for y in room.y:
				free_spots.erase(new_position+ Vector2i(x,y))
		return new_position
	
	
	return Vector2(-999,-999)



func create_doors(doors_position:Array):
	for door in doors_position:
		if doors_position.count(door) >=2:
			tile_map.erase_cell(door["pos"])
			tile_map.erase_cell(door["pos"]+Vector2(0,1))
			tile_map.erase_cell(door["pos"]+Vector2(1,0))
			tile_map.erase_cell(door["pos"]+Vector2(0,-1))
			tile_map.erase_cell(door["pos"]+Vector2(-1,0))
			var new_door:Door = doorScene.instantiate()
			new_door.sidaways = door["side"]
			new_door.position = (Vector2i(door["pos"].x,door["pos"].y))*tile_map.tile_set.tile_size + Vector2i(32,32)
			call_deferred("add_child",new_door)
			doorScenes.append(new_door)
			
	


func generate_level():
	var totalDungeonSize = dungeon.dungeon_size * room_size
	for x in totalDungeonSize.x+room_size:
		for y in totalDungeonSize.y+room_size:
			tile_map.set_cell(Vector2(x,y),3,Vector2(3,3))
	
	minimap_layer.set_map(dungeon)
	
	for i in dungeon.room_types:
		generate_rooms(i.position,i.room_shape)
		if i.roomName == "spawn":
			player.position = (i.position)*tile_map.tile_set.tile_size
		
		
		minimap_layer.generate_rooms(i.position*4/room_size,i.room_shape)
		var blocker = minimap_layer.hide_room(i.position*4/room_size,i.room_shape)
		
		
		if i.roomMap:
			var new_room:Room = i.roomMap.pick_random().instantiate()
			dungeon_fuel += new_room.enemy_manager.budget *5
			new_room.position = (i.position- Vector2i(1,1)*dungeon.room_radius)*tile_map.tile_set.tile_size 
			add_child(new_room)
			new_room.getDoors()
			new_room.blocker = blocker
			player.rooms_to_explore.append(new_room)
	
	for i in free_spots:
		var baseRoom = dungeon.room_types[0]
		generate_rooms(i*room_size,baseRoom.room_shape)
		
		minimap_layer.generate_rooms(i*4,baseRoom.room_shape)
		var blocker = minimap_layer.hide_room(i*4,baseRoom.room_shape)
		
		var new_room:Room = baseRoom.roomMap.pick_random().instantiate()
		dungeon_fuel += new_room.enemy_manager.budget *5 *2
		new_room.position = (i*room_size - Vector2i(1,1)*dungeon.room_radius)*tile_map.tile_set.tile_size 
		add_child(new_room)
		new_room.getDoors()
		new_room.blocker = blocker
		player.rooms_to_explore.append(new_room)
	
	create_doors(doors_positions)
	minimap_layer.create_doors(minimap_layer.doors_positions)
	
	var used_cells = tile_map.get_used_cells()
	tile_map.set_cells_terrain_connect(used_cells,1 , 1)

func change_to_results():
	get_tree().change_scene_to_file("res://result_screen.tscn")
	HitstopEfect.swap_to_level_out()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
