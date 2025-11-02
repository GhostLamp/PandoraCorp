extends TileMapLayer
@onready var timer: Timer = $Timer



func _on_timer_timeout() -> void:
	timer.start()
	var used_cells:Array[Vector2i]
	var corner_cells:Array[Vector2i]
	var middle_cells = get_used_cells_by_id(1,Vector2(1,1))

	for i in 11:
		for k in 5:
			if Vector2(i,k) == Vector2(3,4) or  Vector2(i,k) == Vector2(1,1):
				continue
			
			corner_cells.append_array(get_used_cells_by_id(1,Vector2(i,k)))
	
	used_cells.append_array(middle_cells)
	used_cells.append_array(corner_cells)
	
	if used_cells.size() == 0:
		return
	
	if corner_cells.size() == 0:
		for i in middle_cells:
			set_cell(i,1,Vector2(3,3))
		set_cells_terrain_connect(middle_cells,0 , 0)
		return
	
	
	for i in corner_cells:
		set_cell(i,1,Vector2(3,4))
