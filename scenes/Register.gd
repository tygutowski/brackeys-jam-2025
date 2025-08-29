extends Area2D

var biscuit: Biscuit
var biscuit_price: int = 10
@export var fancyoven: Node2D

func cash_out() -> void:
	if fancyoven != null:
		if fancyoven.biscuit != null:
			if fancyoven.grabbable:
				biscuit = fancyoven.register_grab()
	if biscuit != null:
		var value = floor(biscuit_price * biscuit.quality)
		$AudioStreamPlayer.play()
		Global.money += value
		biscuit = null
