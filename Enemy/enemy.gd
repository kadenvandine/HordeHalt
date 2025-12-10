extends PathFollow3D

@export var max_health := 50
@export var gold_value := 15

@onready var base = get_tree().get_first_node_in_group("base")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bank = get_tree().get_first_node_in_group("bank")

var speed := 5.0
var _is_burning := false
var _burn_timer := 0.0
const BURN_TICK_RATE := 0.2

var current_health: int:
	set(health_in):
		if health_in < current_health:
			animation_player.play("TakeDamage")
		current_health = health_in
		if current_health < 1:
			bank.gold += gold_value
			queue_free()
			
func apply_burn_damage(damage_per_tick: int, duration: float) -> void:
	if not _is_burning:
		print("BURN STATUS RECEIVED AND STARTING TIMER.")
		_is_burning = true
		_burn_timer = duration
		
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = BURN_TICK_RATE
		timer.timeout.connect(_on_burn_tick.bind(damage_per_tick, timer))
		timer.start()

func _on_burn_tick(damage: int, timer: Timer) -> void:
	print("TIMER TICK: Applying damage")
	if _burn_timer > 0:
		print("PRE-DAMAGE HEALTH:", current_health)
		print("TICK DAMAGE: ", damage)
		current_health -= damage
		print("POST-DAMAGE HEALTH: ", current_health)
		_burn_timer -= timer.wait_time
	else:
		_is_burning = false
		timer.queue_free()

func _ready() -> void:
	current_health = max_health
	Engine.time_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio == 1.0:
		base.take_damage()
		set_process(false)
		queue_free()
