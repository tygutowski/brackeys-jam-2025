extends Sprite2D

var biscuit: Biscuit = null

func create_tray() -> void:
	biscuit = Biscuit.new()
	biscuit.stage = biscuit.stageEnum.SHAPED

func get_biscuit() -> void:
	biscuit = null
	$AnimationPlayer.play("make_dough")
