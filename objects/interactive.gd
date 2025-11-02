class_name interactive
extends Node2D

@onready var Fkey:Sprite2D = $Fkey
var showing:bool = false

var tween:Tween
var interactable:bool = true

func showFKey():
	Fkey.visible = true



func hideFKey():
	Fkey.visible = false


func interact(_player: Player):
	pass
	
