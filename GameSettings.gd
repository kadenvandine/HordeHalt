extends Node

const SPAWN_EASY = preload("res://difficulty_spawn_easy.tres")
const SPAWN_NORMAL = preload("res://difficulty_spawn_normal.tres")
const SPAWN_HARD = preload("res://difficulty_spawn_hard.tres")

const HEALTH_EASY = preload("res://difficulty_health_easy.tres")
const HEALTH_NORMAL = preload("res://difficulty_health_normal.tres")
const HEALTH_HARD = preload("res://difficulty_health_hard.tres")

const SPEED_EASY = preload("res://difficulty_speed_easy.tres")
const SPEED_NORMAL = preload("res://difficulty_speed_normal.tres")
const SPEED_HARD = preload("res://difficulty_speed_hard.tres")

const SPAWN_CURVES = [SPAWN_EASY, SPAWN_NORMAL, SPAWN_HARD]
const HEALTH_CURVES = [HEALTH_EASY, HEALTH_NORMAL, HEALTH_HARD]
const SPEED_CURVES = [SPEED_EASY, SPEED_NORMAL, SPEED_HARD]

var selected_difficulty_index := 1

func set_difficulty_index(index: int):
	if index >= 0 and index < SPAWN_CURVES.size():
		selected_difficulty_index = index
		print("Difficulty set to: ", index)

func get_current_spawn_curve() -> Curve:
	return SPAWN_CURVES[selected_difficulty_index]
	
func get_current_health_curve() -> Curve:
	return HEALTH_CURVES[selected_difficulty_index]

func get_current_speed_curve() -> Curve:
	return SPEED_CURVES[selected_difficulty_index]
