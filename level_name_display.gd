extends CanvasLayer

@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3



func show_level(name1:String,name2:String,level:String):
	label.text = name1
	label_2.text = name2
	label_3.text = level
