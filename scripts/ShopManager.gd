extends Room

var camera_pos: Vector2 = Vector2(1248, 152)

func entered() -> void:
	var audio_players = find_children("AudioStream*", "AudioStreamPlayer")
	for audio_player: AudioStreamPlayer in audio_players:
		audio_player.volume_linear = .3
	get_node("Doorbell").play()

func exited() -> void:
	var audio_players = find_children("AudioStream*", "AudioStreamPlayer")
	for audio_player: AudioStreamPlayer in audio_players:
		audio_player.volume_linear = 0
	get_node("Doorbell").playing = false
