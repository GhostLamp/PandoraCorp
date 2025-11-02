extends Node
class_name RoomCarver



var roomToCreate:RoomCalculator
var doors = []
var rooms = []

func _init(room:RoomCalculator):
	roomToCreate = room

func makeRoom():
	carve_room()
	carve_door()
	var result:CarvedArea = CarvedArea.new()
	result.room = rooms
	result.door = doors
	return result


func carve_room():
	var roomx = roomToCreate.type.x
	var roomy = roomToCreate.type.y
	var size = Vector2(roomToCreate.size*roomx + roomx -2,roomToCreate.size*roomy + roomy -2).ceil()
	var top_left_corner = (roomToCreate.start_position - Vector2(roomToCreate.radius,roomToCreate.radius)).ceil()
	
	if roomx>1:
		size.x -=1
	if roomy>1:
		size.y -=1
	
	
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x,y)
			rooms.append(new_step)


func carve_door():
	for i in roomToCreate.door_positions:
		doors.append({"pos":i["pos"]*(roomToCreate.radius+1) + (roomToCreate.start_position),"side":i["side"]})
	
	
