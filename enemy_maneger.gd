extends Node2D
class_name EnemyManeger

@export var expOrb: PackedScene
@export var spawnableEnemies:Array[PackedScene] = []
@export var budget:float
@export var overtime_budget:float
@export var cost_mult:int = 5
var enemies : Array = []
var fuel_orbs:Array = []

func spawn(enemy:Enemy):
	enemy.style.connect(style_bonus)
	enemies.append(enemy)
	enemy.hit_anim.play("spawn")

func Overtime_extra(cells:Array):
	if enemies.size() >= overtime_budget/1.5:
		return
	
	spawn_single(cells)

func spawn_single(cells:Array):
	var new_enemy:Enemy = spawnableEnemies.pick_random().instantiate()
	new_enemy.position = cells.pick_random() * 64
	budget -= new_enemy.cost
	call_deferred("add_child", new_enemy)

func spawn_to_mini(cells:Array,_mini:Minigame):
	var new_enemy:MinigameSpoober = spawnableEnemies.pick_random().instantiate()
	new_enemy.position = cells.pick_random() * 64
	budget -= new_enemy.cost
	new_enemy.minigame = _mini
	call_deferred("add_child", new_enemy)

func startFight(cells:Array):
	var i = budget
	while i > 0:
		var new_enemy:Enemy = spawnableEnemies.pick_random().instantiate()
		new_enemy.position = cells.pick_random() * 64
		i -= new_enemy.cost
		call_deferred("add_child", new_enemy)
		
		

func style_bonus(Style_name):
	get_tree().current_scene.player.stylish(Style_name)
	

func kill_enemy(enemy:Enemy):
	enemies.erase(enemy)
	
	for i in enemy.cost*cost_mult:
		var New_exp:ExpOrb = expOrb.instantiate()
		New_exp.position = enemy.position + Vector2(randf_range(-64,64),randf_range(-64,64))
		New_exp.direction = (New_exp.position - enemy.position + enemy.Target).normalized()
		fuel_orbs.append(New_exp)
		call_deferred("add_child", New_exp)
	
	
	enemy.queue_free()
	if enemies.size() <=0:
		get_parent().end_wave()
	
	

func delete_enemy(enemy:Enemy):
	await get_tree().create_timer(0.2).timeout
	enemies.erase(enemy)
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
