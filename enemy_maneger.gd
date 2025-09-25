extends Node2D
class_name EnemyManeger

@export var expOrb: PackedScene
@export var spawnableEnemies:Array[PackedScene] = []
@export var budget:float
@export var overtime_budget:float
var enemies : Array = []
var fuel_orbs:Array = []

func spawn(enemy:Enemy):
	enemy.style.connect(style_bonus)
	enemies.append(enemy)
	enemy.hit_anim.play("spawn")

func Overtime_extra(cells:Array):
	if enemies.size() >= overtime_budget/1.5:
		return
	
	var new_enemy:Enemy = spawnableEnemies.pick_random().instantiate()
	new_enemy.position = cells.pick_random() * 64
	budget -= new_enemy.cost
	call_deferred("add_child", new_enemy)

func startFight(cells:Array):
	while budget > 0:
		var new_enemy:Enemy = spawnableEnemies.pick_random().instantiate()
		new_enemy.position = cells.pick_random() * 64
		budget -= new_enemy.cost
		call_deferred("add_child", new_enemy)

func style_bonus(Style_name):
	get_tree().current_scene.player.stylish(Style_name)
	

func kill_enemy(enemy:Enemy):
	enemies.erase(enemy)
	for i in enemy.cost*5:
		var New_exp:ExpOrb = expOrb.instantiate()
		New_exp.position = enemy.position + Vector2(randf_range(-64,64),randf_range(-64,64))
		New_exp.direction = (New_exp.position - enemy.position).normalized()
		fuel_orbs.append(New_exp)
		call_deferred("add_child", New_exp)
	enemy.queue_free()
	if enemies.size() <=0:
		get_parent().open_room()

func end_room():
	for i in enemies.size():
		enemies[0].queue_free()
		enemies.erase(enemies[0])
	
	for i in fuel_orbs.size():
		fuel_orbs[0].queue_free()
		fuel_orbs.erase(fuel_orbs[0])
	
