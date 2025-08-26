extends Room

var camera_pos: Vector2 = Vector2(896, 152)

func entered() -> void:
	var audio_players = find_children("AudioStream*", "AudioStreamPlayer")
	for audio_player: AudioStreamPlayer in audio_players:
		audio_player.volume_linear = 1
	# just under an hour to be safe
	var seek: float = randf_range(0, 3500)
	get_node("AudioStreamPlayer").seek(seek)
	
