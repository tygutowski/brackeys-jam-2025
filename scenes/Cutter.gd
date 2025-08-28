extends Area2D

var biscuit: Biscuit = null
var in_use: bool = false
const CUT_TIME: float = 6
var timer: float = 0
var item_in_cutter: bool = false

func _process(delta) -> void:
	if biscuit != null:
		if in_use:
			print(biscuit.stage)
			timer += delta
			if timer >= CUT_TIME:
				done_shaping_dough()

func done_shaping_dough():
	in_use = false
	print("done shaping dough")
	biscuit.stage = biscuit.stageEnum.SHAPED

func get_biscuit():
	$AnimationPlayer.play("take")
	print("get biscuit")
	item_in_cutter = false
	var biscuit_to_return: Biscuit = biscuit
	biscuit = null
	return biscuit_to_return

func shape_dough(new_biscuit: Biscuit = null) -> void:
	$AnimationPlayer.play("shaping dough")
	item_in_cutter = true
	in_use = true
	if new_biscuit != null:
		print("using existing dough")
		timer = 0
		biscuit = new_biscuit

func pause_shaping_dough() -> void:
	if in_use:
		$AnimationPlayer.pause()
		in_use = false
