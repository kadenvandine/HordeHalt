extends PathFollow3D

@export var max_health := 50
@export var gold_value := 15

@onready var base = get_tree().get_first_node_in_group("base")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bank = get_tree().get_first_node_in_group("bank")

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
		_is_burning = false
		timer.queue_free()
