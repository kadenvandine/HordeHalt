extends Area3D

var damage_per_tick := 20
var duration := 4.0
var enemies_in_fire: Array[Node] = []

func _ready():
	body_entered.connect(_on_contact)
	area_entered.connect(_on_contact)
	body_exited.connect(_on_exit)
	area_exited.connect(_on_exit)
	
	var residual_timer = find_child("ResidualTimer", true, false)
	if residual_timer:
		residual_timer.wait_time = 0.5
		residual_timer.timeout.connect(_on_residual_timer_timeout)
		residual_timer.start()

func _on_contact(node: Node):
	var target_enemy = get_damageable_parent(node)
	if target_enemy and not enemies_in_fire.has(target_enemy):
		print("Added to burn list: ", target_enemy.name)
		enemies_in_fire.append(target_enemy)

func _on_exit(node: Node):
	var target_enemy = get_damageable_parent(node)
	if target_enemy and enemies_in_fire.has(target_enemy):
		enemies_in_fire.erase(target_enemy)

func _on_residual_timer_timeout():
	# Loop backwards so we can safely remove dead enemies
	for i in range(enemies_in_fire.size() - 1, -1, -1):
		var enemy = enemies_in_fire[i]
		if is_instance_valid(enemy):
			if enemy.has_method("apply_burn_damage"):
				enemy.apply_burn_damage(damage_per_tick, duration)
		else:
			enemies_in_fire.remove_at(i)

func get_damageable_parent(node: Node) -> Node:
	var current = node
	while current:
		if current.has_method("apply_burn_damage"):
			return current
		current = current.get_parent()
		if current == get_tree().root: return null
	return null
