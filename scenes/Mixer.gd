extends Area2D

var in_use: bool = false
var item_in_mixer: bool = false
const MIX_TIME: float = 20

var biscuit: Biscuit = null

var timer: float = 0

func _process(delta) -> void:
	if item_in_mixer and in_use:
		timer += delta
		if timer >= MIX_TIME:
			stop_mixer()
		else:
			get_node("Timer").text = str(max(0, int(MIX_TIME - timer) + 1))
	else:
		timer = 0

func get_biscuit():
	get_node("Timer").visible = false
	var biscuit_to_return: Biscuit = biscuit
	biscuit = null
	item_in_mixer = false
	return biscuit_to_return

func stop_mixer():
	get_node("Timer").text = "DONE"
	biscuit.stage = biscuit.stageEnum.RAW
	$AnimationPlayer.play("off")
	in_use = false

func start_mixer(new_biscuit):
	biscuit = new_biscuit
	$AnimationPlayer.play("mixing")
	item_in_mixer = true
	in_use = true
	timer = 0

func get_time_left() -> String:
	if timer <= MIX_TIME * 0.25:
		return("The dough has a long ways to go")
	elif timer <= MIX_TIME * 0.50:
		return("The ingredients have started to mix")
	elif timer <= MIX_TIME * 0.75:
		return("A ball of dough has formed")
	elif timer <= MIX_TIME:
		return("The dough is nearly done")
	else:
		return("HOW DID WE GET HERE?")
