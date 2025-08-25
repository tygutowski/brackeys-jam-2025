extends Node2D
class_name Room

func entered() -> void:
	var audio_players = find_children("AudioStream*", "AudioStreamPlayer")
	for audio_player: AudioStreamPlayer in audio_players:
		audio_player.volume_linear = 1

func exited() -> void:
	var audio_players = find_children("AudioStream*", "AudioStreamPlayer")
	for audio_player: AudioStreamPlayer in audio_players:
		audio_player.volume_linear = 0
