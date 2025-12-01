extends CanvasLayer

@onready var star_1 = %Star1
@onready var star_2 = %Star2
@onready var star_3 = %Star3
@onready var base = get_tree().get_first_node_in_group("base")
@onready var health_label = %HealthLabel
@onready var bank = get_tree().get_first_node_in_group("bank")
@onready var gold_label = %GoldLabel
@onready var failed_health_label = %FailedHealthLabel
@onready var failed_gold_label = %FailedGoldLabel

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func victory() -> void:
	visible = true
	get_tree().paused = true
	if base.max_health == base.current_health:
		star_2.modulate = Color.WHITE
		health_label.visible = true
		failed_health_label.visible = false
	if bank.gold >= 500:
		star_3.modulate = Color.WHITE
		gold_label.visible = true
		failed_gold_label.visible = false

func _on_retry_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()
