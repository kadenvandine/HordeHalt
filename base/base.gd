extends Node3D

@export var max_health: int = 5
@export var defeat_layer: CanvasLayer

var current_health: int:
	set(health_in):
		current_health = health_in
		label_3d.text = str(current_health) + "/" + str(max_health)
		var red: Color = Color.RED
		var white: Color = Color.WHITE
		label_3d.modulate = red.lerp(white, float(current_health)/float(max_health))
		if current_health < 1:
			if is_instance_valid(defeat_layer):
				defeat_layer.defeat()
			else:
				print("DefeatLayer node not assigned to base.gd in the Inspector!")
				get_tree().reload_current_scene()

@onready var label_3d: Label3D = $Label3D

func _ready() -> void:
	current_health = max_health

func take_damage() -> void:
	current_health -= 1
