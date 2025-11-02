extends Node
class_name RoomCalculator

var size:int  = 1
var type:Vector2 = Vector2(1,1)
var room_position: Array = []
var door_positions:Array[Dictionary]
var radius: int = 1
var start_position:Vector2


func _init(room_type,pos,room_size,room_radius):
	type = room_type
	start_position = pos
	size = room_size
	radius = room_radius
	find_rooms()
	find_doors()

 
func find_rooms():
	for x in type.x:
		for y in type.y:
			room_position.append(Vector2(x,y))

func find_doors():
	for i in room_position:
		for f in 4:
			var new_door = i+Vector2(cos(f*PI/2),sin(f*PI/2))
			if not (new_door in room_position):
				if roundf(sin(f*PI/2)) != 0:
					door_positions.append({"pos":new_door+(i),"side":true})
					continue
				door_positions.append({"pos":new_door+(i),"side":false})
