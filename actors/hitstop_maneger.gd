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
	

func hitstop_long():
	await get_tree().create_timer(0.01, true, false, true).timeout
	Engine.time_scale = 0
	await get_tree().create_timer(0.5, true, false, true).timeout
	Engine.time_scale =1 
