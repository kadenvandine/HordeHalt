extends Path3D

@export var enemy_scene: PackedScene
@export var difficulty_manager: Node
@onready var timer = $Timer

func spawn_enemy() -> void:
	var new_enemy = enemy_scene.instantiate()
	new_enemy.max_health = difficulty_manager.get_enemy_health()
	add_child(new_enemy)
	timer.wait_time = difficulty_manager.get_spawn_time()
	print(new_enemy.current_health)
	new_enemy.tree_exited.connect(enemy_defeated)


func _on_difficulty_manager_stop_spawning_enemies():
	timer.stop()

func enemy_defeated() ->  void:
	if timer.is_stopped():
		for child in get_children():
			if child  is PathFollow3D:
				return
		print("you won!")
		
