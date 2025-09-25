extends Node2D


@onready var enemy_maneger: Node2D = $enemy_maneger

var tiles_placed = []
var dungeon_fuel:float = 0
var room_placed = []
var room_size = 1
var doors_positions = []
var free_spots:Array = []



@export var tile_map:TileMapLayer
@export var player:Player
@export var dungeon:Dungeon
var doorScenes:Array[Door]



func _ready():
	var new_player = PlayerHolder.player.instantiate()
	call_deferred("add_child",new_player)
	player = new_player
	player.currentPalette = PlayerHolder.current_palette
	player.paletts = PlayerHolder.paletts
	
	room_size = dungeon.room_radius*2 + 2
	
	for x in dungeon.dungeon_size.x:
		for y in dungeon.dungeon_size.y:
			free_spots.append(Vector2i(x,y)+Vector2i(1,1))
	
	for spot in dungeon.erase_spots:
		free_spots.erase(spot)
	
	
	for i in dungeon.room_types:
		i.position = room_size* tile_fill(i.room_shape)
	
	generate_level()
	player.maxFuel = dungeon_fuel*2/3 


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
			tile_map.erase_cell(door)
			tile_map.erase_cell(door+Vector2(0,1))
			tile_map.erase_cell(door+Vector2(1,0))
			tile_map.erase_cell(door+Vector2(0,-1))
			tile_map.erase_cell(door+Vector2(-1,0))


func generate_level():
	var totalDungeonSize = dungeon.dungeon_size * room_size
	for x in totalDungeonSize.x+room_size:
		for y in totalDungeonSize.y+room_size:
			tile_map.set_cell(Vector2(x,y),3,Vector2(3,3))
	
	for i in dungeon.room_types:
		generate_rooms(i.position,i.room_shape)
		if i.roomName == "spawn":
			player.position = (i.position)*tile_map.tile_set.tile_size
	
	for i in free_spots:
		var baseRoom = dungeon.room_types[0]
		generate_rooms(i*room_size,baseRoom.room_shape)
		
		var new_room:Node2D = baseRoom.roomMap.pick_random().instantiate()
		dungeon_fuel += new_room.enemy_manager.budget *5
		new_room.position = (i*room_size - Vector2i(1,1)*dungeon.room_radius)*tile_map.tile_set.tile_size 
		add_child(new_room)
		new_room.getDoors()
		
	
	create_doors(doors_positions)
	
	var used_cells = tile_map.get_used_cells()
	tile_map.set_cells_terrain_connect(used_cells,1 , 1)
	
	for i in dungeon.room_types:
		if i.roomMap:
			var new_room:Room = i.roomMap.pick_random().instantiate()
			dungeon_fuel += new_room.enemy_manager.budget *5
			new_room.position = (i.position- Vector2i(1,1)*dungeon.room_radius)*tile_map.tile_set.tile_size 
			add_child(new_room)
			new_room.getDoors()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		get_tree().reload_current_scene()
