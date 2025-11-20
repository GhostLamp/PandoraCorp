extends Node

var player:PackedScene
var paletts:Array[ShaderMaterial]
var current_palette:int


var win:bool = true
var time:float = 0
var amountHit:float = 0
var totalfuel:float = 0
var extras:Array[Dictionary] = []

func reset():
	win = true
	time = 0
	amountHit = 0
	totalfuel = 0
	extras.clear()
