extends Area2D

var in_use: bool = false
var item_in_oven: bool = false
const BAKE_TIME: float = 45 # time for biscuits to be "perfect"
var biscuit: Biscuit

var timer: float = 0

func _process(delta) -> void:
	if item_in_oven and biscuit != null:
		timer += delta
		# double the bake time so it ramps up and back down
		# quality is from 0->1->2->1->0.2, depending on time cooked
		# BAKE_TIME returns a 2 (perfect), 0 seconds returns a 0 (raw)
		# BAKE_TIME +- 5% returns a 1 (cooked), BAKE_TIME * 2 returns 0.2 (burnt)
		biscuit.set_quality(timer, BAKE_TIME * 2)

func start_oven():
	item_in_oven = true
	in_use = true
	timer = 0

func stop_oven():
	item_in_oven = false
	

func get_biscuits():
	var biscuit_to_return: Biscuit = biscuit
	biscuit = null
	return biscuit_to_return
