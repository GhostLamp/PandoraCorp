class_name Gun
extends CharacterBody2D

signal swap_out
signal bullet_shot

@export var bullet : PackedScene
@export var alt_fire : PackedScene

@export var bullet_count: int = 1
@export_range(0, 360) var arc:float = 0
@export var barrel_origin: Marker2D

@export var basic_shot_cost:float = 0
@export var alt_shot_cost:float = 0
@export var basic_shot_speed:float = 0
@export var alt_shot_speed:float = 0
@export var basic_shot_damage:int = 0
@export var alt_shot_damage:int = 0


func shoot():
	pass

func alt_laser():
	pass
