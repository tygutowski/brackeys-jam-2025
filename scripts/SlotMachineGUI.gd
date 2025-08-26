extends CanvasLayer

var spinner1_value = -1
var spinner2_value = -1
var spinner3_value = -1

# force the player to win
@export var is_rigged: bool = false
# give the player 2 in a row, but the last isn't a win
@export var edge: bool = false
# make it a win, except the middle one is offset by 1
@export var disappoint: bool = false
var stopping: bool = false

func stop_spinners() -> void:
	# we "await" each wheel spinning, since there's a tween
	# so do NOT stop the next spinner if the current one is stopping.
	# this is for the rigging system (we cant force wheel 2 to
	# lands on something if we don't know what wheel 1 landed on)
	if stopping:
		return
	stopping = true
	
	if not get_node("Spinner1").is_stopped:
		if not get_node("Spinner1").spinning:
			stopping = false
			return
		spinner1_value = await get_node("Spinner1").stop()
	elif not get_node("Spinner2").is_stopped:
		if not get_node("Spinner2").spinning:
			stopping = false
			return
		if is_rigged and spinner1_value != -1:
			spinner2_value = await get_node("Spinner2").stop(spinner1_value)
		elif not is_rigged and not edge and not disappoint:
			spinner2_value = await get_node("Spinner2").stop()
		elif edge and not disappoint:
			spinner2_value = await get_node("Spinner2").stop(spinner1_value)
		elif disappoint:
			print(str((spinner1_value + 1)%10))
			spinner2_value = await get_node("Spinner2").stop((spinner1_value + 1)%10)
	elif not get_node("Spinner3").is_stopped:
		if not get_node("Spinner3").spinning:
			stopping = false
			return
		if is_rigged and spinner1_value != -1:
			spinner3_value = await get_node("Spinner3").stop(spinner1_value)
		elif not is_rigged and not disappoint:
			spinner3_value = await get_node("Spinner3").stop(spinner1_value + randi_range(1, 9))
		elif disappoint:
			spinner3_value = await get_node("Spinner3").stop(spinner1_value)
	stopping = false
