extends Sprite2D

@export var doughbot: Node2D
var biscuit: Biscuit = null
var on: bool = false
@export var register: Node2D
var grabbable: bool = false

func cook() -> void:
	on = true
	biscuit = doughbot.grab_tray()
	$AnimationPlayer.play("cook")

func send_to_register():
	biscuit.stage = biscuit.stageEnum.COOKED
	biscuit.quality = 1.0
	grabbable = true
	
func register_grab():
	grabbable = false
	var biscuit_to_return = biscuit
	on = false
	biscuit = null
	$Node2D/cooked.visible = false
	return biscuit_to_return
