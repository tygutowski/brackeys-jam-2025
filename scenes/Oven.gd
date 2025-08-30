extends Area2D

var item_in_oven: bool = false
var bake_time: float
var biscuit: Biscuit
var default_bake_time: float = 30
var bake_time_range: float = 10

func _process(delta) -> void:
	if item_in_oven and biscuit != null:
		# double the bake time so it ramps up and back down
		# quality is from 0->1->2->1->0.2, depending on time cooked
		# BAKE_TIME returns a 2 (perfect), 0 seconds returns a 0 (raw)
		# BAKE_TIME +- 5% returns a 1 (cooked), BAKE_TIME * 2 returns 0.2 (burnt)
		biscuit.cook(delta) # increase the amount that the biscuit is cooked
		if biscuit.quality == 1:
			get_node("Timer").text = "PERFECTLY COOKED"
		elif biscuit.quality == 0 and biscuit.time_cooked > 1:
			get_node("Timer").text = "BURNT"
		else:
			if biscuit.time_cooked > biscuit.bake_time:
				get_node("Timer").text = "OVERCOOKED BY " + str(abs(int(biscuit.bake_time - biscuit.time_cooked)))
			else:
				get_node("Timer").text = "DONE IN " + str(max(0, int(biscuit.bake_time - biscuit.time_cooked)))

		biscuit.set_quality(biscuit.bake_time * 2)

func cook_biscuit(new_biscuit):
	$AnimationPlayer.play("on")
	print("cooking biscuit")
	biscuit = new_biscuit
	if biscuit.stage == biscuit.stageEnum.SHAPED:
		biscuit.bake_time = randf_range(
			default_bake_time - bake_time_range,
			default_bake_time + bake_time_range)
		biscuit.stage = biscuit.stageEnum.COOKED
	item_in_oven = true

func get_biscuit():
	$AnimationPlayer.play("off")
	print("getting biscuit")
	var biscuit_to_return: Biscuit = biscuit
	biscuit = null
	item_in_oven = false
	return biscuit_to_return
