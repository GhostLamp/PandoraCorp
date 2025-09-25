#the class for dungeons
#if you create a resorce that extends this you willbe able to set all off the parameters of the dungeon
#and then add the resorce to your worlds dungeon
extends Resource
class_name Dungeon

#size of the dungeon, a dungeon of size (1,1) has a single room, a (3,3) has a 3 by 3 of rooms
@export var dungeon_size:Vector2i

#the size of the cells of an room, a radius of 2 makes 5 by 5 rooms
@export var room_radius:int

#what styles of rooms will apper in your dungeon
#WARNING: aways have at least one room_type,since the first room on the array is used as a base for the dungeon
#WARNING: its recomended that the base room has an Room Shape of (1,1)
@export var room_types:Array[RoomType]


#choose some spoots of your dungeon to not generate, a dungeon of size (3,3) and erase_spot on (2,2)
#will be missing the middle piece
@export var erase_spots:Array[Vector2i]
