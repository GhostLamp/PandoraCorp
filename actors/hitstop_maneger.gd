extends Node

func hitstop_weak():
	await get_tree().create_timer(0.01, true, false, true).timeout
	Engine.time_scale = 0
	await get_tree().create_timer(0.05, true, false, true).timeout
	Engine.time_scale =1 

func hitstop_short():
	await get_tree().create_timer(0.01, true, false, true).timeout
	Engine.time_scale = 0
	await get_tree().create_timer(0.15, true, false, true).timeout
	Engine.time_scale =1 
	

func hitstop_medium():
	await get_tree().create_timer(0.01, true, false, true).timeout
	Engine.time_scale = 0
	await get_tree().create_timer(0.25, true, false, true).timeout
	Engine.time_scale =1 

func slowdown():
	var level:Level = get_tree().current_scene
	await get_tree().create_timer(0.01, true, false, true).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(Engine,"time_scale",0.3,0.5)
	tween.parallel().tween_property(level,"modulate",Color8(1,1,1,10),0.5)
	tween.parallel().tween_property(level.player.camera_2d,"zoom",Vector2(1.5,1.5),0.5)
	
	tween.tween_property(HitstopEfect.fuel_full_label,"visible_ratio",0.1,0.1)
	tween.tween_property(HitstopEfect.fuel_full_label,"visible_ratio",1,0.3)
	
	tween.tween_property(Engine,"time_scale",1,0.2)
	tween.parallel().tween_property(level.player.camera_2d,"zoom",Vector2(1,1),0.2)
	tween.parallel().tween_property(level,"modulate",Color8(255,255,255,255),0.2)
	tween.parallel().tween_property(HitstopEfect.fuel_full_label,"modulate",Color.TRANSPARENT,0.2)
	tween.tween_callback(overtime_wave)

func overtime_wave():
	print("bruh")
	HitstopEfect.overtime_start()

func hitstop_long():
	await get_tree().create_timer(0.01, true, false, true).timeout
	Engine.time_scale = 0
	await get_tree().create_timer(0.5, true, false, true).timeout
	Engine.time_scale =1 
