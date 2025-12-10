extends Area3D

var damage_per_tick := 2
var duration := 4.0

var enemies_in_fire: Array[Node3D] = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if has_node("ResidualTimer"):
		var residual_timer = $ResidualTimer as Timer
		residual_timer.wait_time = 0.5
		residual_timer.timeout.connect(_on_residual_timer_timeout)
		residual_timer.start()

func _on_body_entered(body: Node3D):
	if body.is_in_group("enemy") and not enemies_in_fire.has(body):
		enemies_in_fire.append(body)

func _on_body_exited(body: Node3D):
	if enemies_in_fire.has(body):
		enemies_in_fire.erase(body)

func _on_residual_timer_timeout():
	for enemy in enemies_in_fire:
		if is_instance_valid(enemy) and enemy.has_method("apply_burn_damage"):
			enemy.apply_burn_damage(damage_per_tick, duration)
