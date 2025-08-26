extends CanvasLayer

var plays: int = 0
@onready var jackpot: int = randi_range(150, 300)
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

func is_any_spinning() -> bool:
	return get_node("SubViewport/Spinner1").spinning or get_node("SubViewport/Spinner2").spinning or get_node("SubViewport/Spinner3").spinning

func _process(_delta) -> void:
	$SlotMachine/Label2.text = str(plays)
	$SlotMachine/Label4.text = str(jackpot)

func stop_spinners() -> void:
	if not is_any_spinning():
		return
	# we "await" each wheel spinning, since there's a tween
	# so do NOT stop the next spinner if the current one is stopping.
	# this is for the rigging system (we cant force wheel 2 to
	# lands on something if we don't know what wheel 1 landed on)
	if stopping:
		return
	stopping = true
	
	# if the wheel is starting, dont stop it
	# (it must be at full speed)
	if not get_node("SubViewport/Spinner1").is_stopped:
		if not get_node("SubViewport/Spinner1").spinning:
			stopping = false
			return
		spinner1_value = await get_node("SubViewport/Spinner1").stop()
	elif not get_node("SubViewport/Spinner2").is_stopped:
		if not get_node("SubViewport/Spinner2").spinning:
			stopping = false
			return
		if is_rigged and spinner1_value != -1:
			spinner2_value = await get_node("SubViewport/Spinner2").stop(spinner1_value)
		elif not is_rigged and not edge and not disappoint:
			spinner2_value = await get_node("SubViewport/Spinner2").stop()
		elif edge and not disappoint:
			spinner2_value = await get_node("SubViewport/Spinner2").stop(spinner1_value)
		elif disappoint:
			print(str((spinner1_value + 1)%10))
			spinner2_value = await get_node("SubViewport/Spinner2").stop((spinner1_value + 1)%10)
	elif not get_node("SubViewport/Spinner3").is_stopped:
		if not get_node("SubViewport/Spinner3").spinning:
			stopping = false
			return
		if is_rigged and spinner1_value != -1:
			spinner3_value = await get_node("SubViewport/Spinner3").stop(spinner1_value)
		elif not is_rigged and not disappoint:
			spinner3_value = await get_node("SubViewport/Spinner3").stop(spinner1_value + randi_range(1, 9))
		elif disappoint:
			spinner3_value = await get_node("SubViewport/Spinner3").stop(spinner1_value)
	if not is_any_spinning():
		if spinner1_value == spinner2_value and spinner2_value == spinner3_value:
			$AnimationPlayer.play("jackpot")
			match spinner1_value:
				0: # seven (A tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot/3)
					get_node("../UI").increase_money(70)
				1: # lemon (C tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot/7)
					get_node("../UI").increase_money(30)
				2: # diamond (A tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot/3)
					get_node("../UI").increase_money(70)
				3: # biscuit (S tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot)
					get_node("../UI").increase_money(jackpot)
					jackpot = randi_range(150, 300)
				4: # horseshoe (B tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot/5)
					get_node("../UI").increase_money(50)
				5: # heart (C tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot/7)
					get_node("../UI").increase_money(30)
				6: # clover (A tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot/3)
					get_node("../UI").increase_money(70)
				7: # melon (C tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot/7)
					get_node("../UI").increase_money(30)
				8: # cherry (B tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot/5)
					get_node("../UI").increase_money(50)
				9: # bar (B tier)
					$"SlotMachine/3CoinParticle".amount = int(jackpot/5)
					get_node("../UI").increase_money(50)

	stopping = false
