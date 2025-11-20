extends Node2D

@export var timer_label : Label
@export var timer_lost : Label
@export var combo_label : Label

@onready var combo_counter: Node = $combo_counter
@onready var timer = $timer
@onready var timer_wait_time = $timer/wait_time
@onready var combo_bar: TextureProgressBar = $combo_bar

func _process(_delta: float) -> void:
	update_timer()
	update_combo()

func update_timer():
	timer_label.text = timer.time_left()

func update_combo():
	combo_bar.value = combo_counter.combo_time_left()%100
	combo_label.text = combo_counter.combo_left()
	


func _on_wait_time_timeout() -> void:
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(timer_lost, "position", Vector2(96,231) , 0.2)
	tween.tween_property(timer_lost ,"modulate" ,Color.TRANSPARENT , 0.1)
	timer_lost.text = timer.time_drain_left()


func _on_timer_time_changed() -> void:
	var tween = get_tree().create_tween()
	timer_lost.modulate = Color.RED
	timer_lost.modulate.a = 0
	tween.tween_property(timer_lost ,"modulate" ,Color.RED , 0.1)
	timer_lost.position.y = 231
	timer_lost.text = timer.time_drain_left()
