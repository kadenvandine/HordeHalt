extends Node3D

@onready var particles: GPUParticles3D = $Particles 
@onready var lifespan_timer: Timer = $Timer 

const EFFECT_DURATION := 0.7 

func play_vfx():
	particles.one_shot = true
	
	particles.emitting = true
	
	lifespan_timer.wait_time = EFFECT_DURATION
	lifespan_timer.start()
	
func _ready():
	particles.emitting = false
	lifespan_timer.timeout.connect(queue_free)


func _on_timer_timeout() -> void:
	queue_free()
