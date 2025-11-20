extends CanvasLayer

@onready var color_map: TileMapLayer = $ColorRect/color_map
@onready var blocker_layer: TileMapLayer = $ColorRect/BlockerLayer
@onready var minimap: TileMapLayer = $ColorRect/minimap
@onready var color_rect: ColorRect = $ColorRect
var dungeon:Dungeon
var room_size:int = 0
var doors_positions = []

func set_map(d:Dungeon):
	doors_positions.clear()
	room_size = 1*2 + 2
	dungeon = d
	var totalMinimapSize = dungeon.dungeon_size*room_size - Vector2i(1,1)
	for x in totalMinimapSize.x+room_size:
		for y in totalMinimapSize.y+room_size:
			minimap.set_cell(Vector2(x,y),0,Vector2(3,3))
	
	color_rect.size = Vector2(totalMinimapSize) * Vector2(minimap.tile_set.tile_size) * minimap.scale*1.2
	color_rect.position = Vector2(1920,1080) - color_rect.size*color_rect.scale- Vector2(40,40)

func generate_rooms(start_p, room_type):
	var new_room = RoomCalculator.new(room_type,start_p,room_size,dungeon.room_radius)
	
	var roomMaker = RoomCarver.new(new_room)
	var area_to_carve:CarvedArea = roomMaker.makeRoom()
	
	var rooms = area_to_carve.room
	
	doors_positions.append_array(area_to_carve.door)
	
	roomMaker.queue_free()
	
	for location in rooms:
		minimap.erase_cell(location+Vector2(13,13))


func hide_room(start_p, room_type):
	#var new_rect = ColorRect.new()
	#print(start_p)
	#new_rect.size = Vector2i(50,50)*room_type + (minimap.tile_set.tile_size * (room_type - Vector2i(1,1)))
	#new_rect.position = Vector2(start_p) * Vector2(minimap.tile_set.tile_size) * minimap.scale * 2 *2
	#color_rect.call_deferred("add_child",new_rect)
	var new_room = RoomCalculator.new(room_type,start_p,room_size,dungeon.room_radius)
	
	var roomMaker = RoomCarver.new(new_room)
	var area_to_carve:CarvedArea = roomMaker.makeRoom()
	
	var rooms = area_to_carve.room
	
	var start = rooms[0]
	var end = rooms[rooms.size()-1]
	
	var distance = end - start + Vector2(3,3)
	var cells = []
	for x in distance.x:
		for y in distance.y:
			blocker_layer.set_cell( Vector2(x,y) +start -Vector2(1,1) +Vector2(13,13)  ,0,Vector2(1,1))
			
			cells.append(Vector2(x,y) +start - Vector2(1,1) +Vector2(13,13))
	
	#for location in roomMaker.room:
		#minimap.set_cell(location,0,Vector2(1,1))
	
	return cells

func showMap(cells:Array,cell_pos):
	var used_cells = minimap.get_used_cells()
	minimap.set_cells_terrain_connect(used_cells,0 , 0)
	for i in cells:
		blocker_layer.erase_cell(i)
		color_map.set_cell(i,0,cell_pos)

func create_doors(doors_position:Array):
	for door in doors_position:
		if doors_position.count(door) >=2:
			minimap.erase_cell(door["pos"]/4)
			print(door["pos"]/4)
