extends CanvasLayer

@onready var stats_tooltip = $StatsTooltip
@onready var stats_label = $StatsTooltip/StatsLabel

@export var turret_button: Button
@export var quickfire_turret_button: Button
@export var flame_turret_button: Button
@export var ray_picker_camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	stats_tooltip.visible = false

	if turret_button:
		turret_button.mouse_entered.connect(_on_turret_mouse_entered)
		turret_button.mouse_exited.connect(_on_mouse_exited)
	
	if quickfire_turret_button:
		quickfire_turret_button.mouse_entered.connect(_on_quickfire_turret_mouse_entered)
		quickfire_turret_button.mouse_exited.connect(_on_mouse_exited)
	
	if flame_turret_button:
		flame_turret_button.pressed.connect(ray_picker_camera._on_build_turret_flame_pressed)
		flame_turret_button.mouse_entered.connect(_on_flame_turret_mouse_entered)
		flame_turret_button.mouse_exited.connect(_on_mouse_exited)

func _process(delta):
	if get_tree().is_paused():
		return
	if stats_tooltip.visible:
		stats_tooltip.global_position = get_viewport().get_mouse_position() + Vector2(15, 15)

func _on_flame_turret_mouse_entered():
	if get_tree().is_paused():
		return
	stats_label.text = FLAME_TURRET_STATS_TEXT
	stats_tooltip.visible = true


func _on_turret_mouse_entered():
	if get_tree().is_paused():
		return
	stats_label.text = TURRET_STATS_TEXT
	stats_tooltip.visible = true


func _on_mouse_exited():
	if get_tree().is_paused():
		return
	stats_label.text = ""
	stats_tooltip.visible = false


func _on_quickfire_turret_mouse_entered():
	if get_tree().is_paused():
		return
	stats_label.text = QUICK_TURRET_STATS_TEXT
	stats_tooltip.visible = true

const TURRET_STATS_TEXT = """
Normal Turret
• Damage: 25
• Reload Speed: 0.60s
• Range: 10
• Cost: 100
"""

const QUICK_TURRET_STATS_TEXT = """
Quickfire Turret
• Damage: 20
• Reload Speed: 0.35s
• Range: 6
• Cost: 150
"""

const FLAME_TURRET_STATS_TEXT = """
Flame Turret
• Fire damage: 2.5/tick
• Fire rate: 0.1
• Duration: 6.0s
• Range: 5
• Spread: 6.25
• Cost: 200
"""
