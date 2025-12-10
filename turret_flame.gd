extends Node3D

@export var flame_range := 5.0
@export var flame_damage_per_tick := 200
@export var flame_duration := 4.0
@export var fire_rate := 0.0

@export var flame_vfx_scene: PackedScene

@onready var cannon: Node3D = $TurretBase/TurretTop/Cannon
@onready var turret_base: Node3D = $TurretBase
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_snd: AudioStreamPlayer3D = $ShootSnd
@onready var timer: Timer = $Timer

var enemy_path: Path3D
var target: PathFollow3D

func _ready() -> void:
	timer.wait_time = fire_rate
	timer.start()

func find_best_target() -> PathFollow3D:
	#If enemy path hasn't been set yet, don't try to loop
	if not is_instance_valid(enemy_path):
		return null	
	
	var best_target = null
	var best_progress = 0
	for enemy in enemy_path.get_children():
		if enemy is PathFollow3D:
			if enemy.progress > best_progress:
				var distance := global_position.distance_to(enemy.global_position)
				if distance < flame_range:
					best_target = enemy
					best_progress = enemy.progress
	return best_target

func _physics_process(delta: float) -> void:
	target = find_best_target()
	if target:
		turret_base.look_at(target.global_position, Vector3.UP, true)

func _on_timer_timeout():
	target = find_best_target()
	
	if target:
		if target.has_method("apply_burn_damage"):
			target.apply_burn_damage(flame_damage_per_tick, flame_duration)
		else:
			print("ERROR: Enemy is missing 'apply_burn_damage' function!")
		
		if not flame_vfx_scene:
			print("ERROR: flame_vfx_scene is NOT assigned in the inspector")
		
		if flame_vfx_scene:
			var flame_vfx = flame_vfx_scene.instantiate()
			add_child(flame_vfx)
			flame_vfx.global_transform = cannon.global_transform
			if flame_vfx.has_method("play_vfx"):
				flame_vfx.play_vfx()
		animation_player.play("fire")
		shoot_snd.play()
