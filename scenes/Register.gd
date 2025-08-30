extends Area2D

var biscuit: Biscuit
var biscuit_price: int = 10
@export var fancyoven: Node2D

func cash_out(held_biscuit: Biscuit) -> bool:
	var success = false
	if held_biscuit:
		biscuit = held_biscuit
	elif fancyoven != null:
		if fancyoven.biscuit != null:
			if fancyoven.grabbable:
				biscuit = fancyoven.register_grab()
	if biscuit != null && $"..".is_customer_at_register():
		var value = floor(biscuit_price * biscuit.quality)
		$AudioStreamPlayer.play()
		Global.money += value
		biscuit = null
		success = true
		# reset luck to full (0 for some stupid reason)
		# when selling cookies
		Global.mood = 0
		$"..".remove_customer()
	return success
