extends Node3D

@export var flame_range := 5.0
@export var flame_damage_per_tick := 2.5
@export var flame_duration := 4.0
@export var fire_rate := 0.1

@export var flame_vfx_scene: PackedScene

@onready var cannon: Node3D = $TurretBase/TurretTop/Cannon
@onready var turret_base: Node3D = $TurretBase
@onready var shoot_snd: AudioStreamPlayer3D = $ShootSnd
@onready var timer: Timer = $Timer

var enemy_path: Path3D
var target: PathFollow3D
var flame_particles: GPUParticles3D = null

func _ready() -> void:
	timer.wait_time = fire_rate
	timer.start()
	
	if flame_vfx_scene:
		var vfx_instance = flame_vfx_scene.instantiate()
		cannon.add_child(vfx_instance) 
		vfx_instance.position = Vector3.ZERO
		
		if vfx_instance.has_node("Particles"):
			flame_particles = vfx_instance.get_node("Particles")
			flame_particles.emitting = false
		
		if vfx_instance.has_node("FlameHitbox"):
			var flame_hitbox_node = vfx_instance.get_node("FlameHitbox")
			flame_hitbox_node.damage_per_tick = flame_damage_per_tick
			flame_hitbox_node.duration = flame_duration

func find_best_target() -> PathFollow3D:
	if not is_instance_valid(enemy_path): return null	
	var best_target = null
	var best_progress = 0

	for enemy in enemy_path.get_children():
		if is_instance_valid(enemy) and enemy is PathFollow3D:
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
		
		if flame_particles and not flame_particles.emitting:
			flame_particles.emitting = true
			
		if not shoot_snd.playing:
			shoot_snd.play()
			
	else:
		if flame_particles and flame_particles.emitting:
			flame_particles.emitting = false
		
		if shoot_snd.playing:
			shoot_snd.stop()

func _on_timer_timeout():
	target = find_best_target()
