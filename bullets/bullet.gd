class_name Bullet
extends CharacterBody2D

@export var speed:float = 0
@export var damage:float = 0
@export var knockback:int = 0
@export var direction: Vector2 = Vector2(0,0)
@export var status_manager: StatusManager
@export var final_speed: float
@export var final_direction: Vector2
@export var pierce:int = 1
@export var enemies_hit:Array = []
@export var quick:bool = false

@export var text: Texture
@export var text_region: Rect2
