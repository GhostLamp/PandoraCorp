extends Area2D


func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		body.set_cell(body.get_coords_for_body_rid(body_rid),0,Vector2(0,0))


func _on_body_shape_exited(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		body.set_cell(body.get_coords_for_body_rid(body_rid),1,Vector2(3,3))
