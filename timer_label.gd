extends Label

@export var difficulty_manager: Node 

func _process(delta: float) -> void:
	if difficulty_manager:
		var time_left = difficulty_manager.get_time_left()
		
		# Calculate minutes and seconds
		var minutes = floor(time_left / 60)
		var seconds = int(time_left) % 60
		
		# Format as "00:00" using the % operator
		text = "%02d:%02d" % [minutes, seconds]
