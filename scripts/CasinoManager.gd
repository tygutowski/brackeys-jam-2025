extends Room

var camera_pos: Vector2 = Vector2(896, 152)

func entered() -> void:
	var audio_players = find_children("AudioStream*", "AudioStreamPlayer")
	for audio_player: AudioStreamPlayer in audio_players:
		audio_player.volume_linear = 1
	# just under an hour to be safe
	var seek: float = randf_range(0, 3500)
	get_node("AudioStreamPlayer").seek(seek)
	$"../../SlotMachine/SubViewport/Spinner1".reel_offset = 16 * randi_range(0, 9)
	$"../../SlotMachine/SubViewport/Spinner2".reel_offset = 16 * randi_range(0, 9)
	$"../../SlotMachine/SubViewport/Spinner3".reel_offset = 16 * randi_range(0, 9)
