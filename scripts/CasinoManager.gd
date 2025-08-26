extends Room

var camera_pos: Vector2 = Vector2(896, 152)

func entered() -> void:
	var audio_players = find_children("AudioStream*", "AudioStreamPlayer")
	for audio_player: AudioStreamPlayer in audio_players:
		audio_player.volume_linear = 1
	get_node("AudioStreamPlayer").seek(randf_range(0, 12000))
