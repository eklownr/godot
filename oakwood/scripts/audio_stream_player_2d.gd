extends AudioStreamPlayer2D

# loop background music
func _on_finished() -> void:
	play(0.0) 
