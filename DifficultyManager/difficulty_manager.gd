extends Node

signal stop_spawning_enemies

@export var game_length := 30.0
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(game_length)

func game_progress_ratio() -> float:
	return 1.0 - (timer.time_left / game_length)

func get_spawn_time() -> float:
	var current_curve = GameSettings.get_current_spawn_curve()
	return current_curve.sample(game_progress_ratio())

func get_enemy_health() -> float:
	var current_curve = GameSettings.get_current_health_curve()
	return current_curve.sample(game_progress_ratio())
	
func get_enemy_speed() -> float:
	var current_curve = GameSettings.get_current_speed_curve()
	return current_curve.sample(game_progress_ratio())

func _on_timer_timeout():
	stop_spawning_enemies.emit()
