extends CanvasLayer

@onready var star_1 = %Star4
@onready var star_2 = %Star5
@onready var star_3 = %Star6

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	
func defeat() -> void:
	visible = true
	get_tree().paused = true

func _on_retry_button_pressed1():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed1():
	get_tree().quit()
