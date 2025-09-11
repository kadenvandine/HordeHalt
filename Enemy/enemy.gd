extends PathFollow3D

@export var speed: float = 5.0

@onready var base = get_tree().get_first_node_in_group("base")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio == 1.0:
		base.take_damage()
		set_process(false)
