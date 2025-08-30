extends Area2D

var biscuit: Biscuit
var biscuit_price: int = 10
@export var fancyoven: Node2D

func cash_out(held_biscuit: Biscuit) -> bool:
	if not $"..".is_customer_at_register():
		return false
	var success = false
	if held_biscuit:
		biscuit = held_biscuit
	elif fancyoven != null:
		if fancyoven.biscuit != null:
			if fancyoven.grabbable:
				biscuit = fancyoven.register_grab()
	if biscuit != null:
		var value = floor(biscuit_price * biscuit.quality)
		#$AudioStreamPlayer.play()
		Global.money += value
		biscuit = null
		success = true
		# reset luck to full (0 for some stupid reason)
		# when selling cookies
		$"../../../UI/MarginContainer/VBoxContainer/Emotion".set_mood(0)
		$"..".remove_customer()
	return success

func has_fancyoven_biscuit() -> bool:
	if fancyoven && fancyoven.grabbable:
		return true
	else:
		return false
