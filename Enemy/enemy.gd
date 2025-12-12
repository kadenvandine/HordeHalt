extends PathFollow3D

@export var max_health := 50
@export var gold_value := 15

@onready var base = get_tree().get_first_node_in_group("base")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bank = get_tree().get_first_node_in_group("bank")
@onready var visual_mesh: MeshInstance3D = $Barbarian/Armature/Skeleton3D/Barbarian_M_02

var speed := 5.0

var _is_burning := false
var _burn_duration_left := 0.0
var _current_burn_tick_damage := 0
const BURN_TICK_RATE := 0.2

var current_health: int:
	set(health_in):
		if health_in < current_health:
			animation_player.play("TakeDamage")
		current_health = health_in
		if current_health < 1:
			bank.gold += gold_value
			queue_free()

func _ready() -> void:
	current_health = max_health

func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio == 1.0:
		base.take_damage()
		set_process(false)
		queue_free()

func apply_burn_damage(damage_per_tick: int, duration: float) -> void:
	_burn_duration_left = duration
	_current_burn_tick_damage = damage_per_tick
	
	if not _is_burning:
		set_burning_visual(true)
		
		print("IGNITION: Starting Burn Timer on ", name)
		_is_burning = true
		
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = BURN_TICK_RATE
		timer.timeout.connect(_on_burn_tick.bind(timer))
		timer.start()

func _on_burn_tick(timer: Timer) -> void:
	if _burn_duration_left > 0:
		current_health -= _current_burn_tick_damage
		_burn_duration_left -= timer.wait_time
	else:
		set_burning_visual(false)
		if visual_mesh and visual_mesh.mesh:
			for i in range(visual_mesh.mesh.get_surface_count()):
				visual_mesh.set_surface_override_material(i, null)
		_is_burning = false
		timer.queue_free()

func set_burning_visual(is_burning: bool):
	if not visual_mesh or not visual_mesh.mesh:
		return

	for i in range(visual_mesh.mesh.get_surface_count()):
		
		var current_override = visual_mesh.get_surface_override_material(i)
		
		if current_override:
			if is_burning:
				current_override.emission_enabled = true
				current_override.emission = Color(1.0, 0.1, 0.0)
				current_override.emission_energy_multiplier = 5.0
				current_override.albedo_color = Color(1.0, 0.6, 0.6)
			else:
				current_override.emission_enabled = false
				current_override.albedo_color = Color(1.0, 1.0, 1.0)
		
		elif is_burning:
			var source_mat = visual_mesh.get_active_material(i)
			
			if source_mat:
				var new_mat = source_mat.duplicate()
				
				if new_mat is BaseMaterial3D:
					new_mat.emission_enabled = true
					new_mat.emission = Color(1.0, 0.1, 0.0)
					new_mat.emission_energy_multiplier = 5.0
					new_mat.albedo_color = Color(1.0, 0.6, 0.6)
					
					visual_mesh.set_surface_override_material(i, new_mat)
					print("VISUAL: Ignited Surface ", i)
