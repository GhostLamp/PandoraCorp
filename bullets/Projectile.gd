extends CharacterBody2D
class_name Projectile

@export var direction := Vector2(1,1)
@export var damage = 1
@export var target = Vector2.RIGHT
@export var charge:float = 1
@export var speed:float = 0
@export var paried = false
@export var gravity:float = 10.0
@export var h:float
@export var yvel: float = 0
@export var spin = 20
@export var drag = 18
@export var dist:Vector2
@export var dono:Array =[]
