extends VBoxContainer

var style_bonus: Array = []
@onready var triple_dot: Label = $"../TripleDot"

func _ready() -> void:
	for child in get_children():
		style_bonus.append(child)



func add_style(style_label):
	add_child(style_label)
	style_bonus.append(style_label)
	adjust_text()

func remove_style():
	if style_bonus.size() > 0:
		for i in style_bonus.size():
			style_bonus[i].style_removed()
		
		await style_bonus[0].fadeout()
		style_bonus[0].queue_free()
		style_bonus.pop_front()
		adjust_text()

func adjust_text():
	if style_bonus.size() > 10:
		remove_style()
		
	for i in style_bonus.size():
		if i < 9:
			style_bonus[i].visible = true
			continue
		
		elif i == 9:
			if style_bonus.size() == 10:
				style_bonus[i].visible = true
				continue
		
		style_bonus[i].visible = false
