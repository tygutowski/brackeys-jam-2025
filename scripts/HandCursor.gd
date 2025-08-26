extends Sprite2D

var mouse_inside: bool = false
var mouse_held_down: bool = false
var cranking: bool = false
var cursor_speed: float = 0
var cursor_position_last_frame: Vector2
var can_tap: bool = false
var can_stop: bool = false
var hand_on_one_cent_coin: bool = false
var hand_on_three_cent_coin: bool = false
var hand_on_seven_cent_coin: bool = false

var denomination_in_hand: int = -1

var holding_coin: bool = false
var hovering_coin_mechanism: bool = false
var coin1_home: Vector2
var coin3_home: Vector2
var coin7_home: Vector2
var time: float = 0
func _ready() -> void:
	get_node("Coin1Sprite").visible = false
	get_node("Coin3Sprite").visible = false
	get_node("Coin7Sprite").visible = false
	cursor_position_last_frame = get_global_mouse_position()
	coin1_home = $"../CoinPurse/Area2D3/1coin".global_position
	coin3_home = $"../CoinPurse/Area2D2/3coin".global_position
	coin7_home = $"../CoinPurse/Area2D/7coin".global_position

func _process(delta: float) -> void:
	time += delta
	$"../CoinPurse/Area2D/7coin".offset.y = sin(time + .5) * 3
	$"../CoinPurse/Area2D2/3coin".offset.y = sin(time + 1) * 3
	$"../CoinPurse/Area2D3/1coin".offset.y = sin(time + 1.5) * 3
	$"../CoinPurse/Area2D/CollisionShape2D".disabled = false
	if denomination_in_hand != 7:
		$"../CoinPurse/Area2D/7coin".visible = true
	$"../CoinPurse/Area2D2/CollisionShape2D2".disabled = false
	if denomination_in_hand != 5:
		$"../CoinPurse/Area2D2/3coin".visible = true
	$"../CoinPurse/Area2D3/CollisionShape2D2".disabled = false
	if denomination_in_hand != 1:
		$"../CoinPurse/Area2D3/1coin".visible = true
	if Global.money < 7:
		$"../CoinPurse/Area2D/CollisionShape2D".disabled = true
		$"../CoinPurse/Area2D/7coin".visible = false
	if Global.money < 5:
		$"../CoinPurse/Area2D2/CollisionShape2D2".disabled = true
		$"../CoinPurse/Area2D2/3coin".visible = false
	if Global.money < 1:
		$"../CoinPurse/Area2D3/CollisionShape2D2".disabled = true
		$"../CoinPurse/Area2D3/1coin".visible = false
	
	
	if hand_on_one_cent_coin:
		if denomination_in_hand == 0:
			$"../CoinPurse/Area2D3/1coin".offset.y = 0
			$"../CoinPurse/Area2D3/1coin".global_position = lerp($"../CoinPurse/Area2D3/1coin".global_position, get_global_mouse_position() + Vector2(6, 12), 0.2)
		if denomination_in_hand == 1:
			$"../CoinPurse/Area2D3/1coin".global_position = coin1_home
			$"../CoinPurse/Area2D3/1coin".visible = false
	else:
		$"../CoinPurse/Area2D3/1coin".global_position = lerp($"../CoinPurse/Area2D3/1coin".global_position, coin1_home, 0.2)
	if hand_on_three_cent_coin:
		if denomination_in_hand == 0:
			$"../CoinPurse/Area2D2/3coin".offset.y = 0
			$"../CoinPurse/Area2D2/3coin".global_position = lerp($"../CoinPurse/Area2D2/3coin".global_position, get_global_mouse_position() + Vector2(6, 12), 0.2)
		if denomination_in_hand == 5:
			$"../CoinPurse/Area2D2/3coin".global_position = coin1_home
			$"../CoinPurse/Area2D2/3coin".visible = false
	else:
		$"../CoinPurse/Area2D2/3coin".global_position = lerp($"../CoinPurse/Area2D2/3coin".global_position, coin3_home, 0.2)
	if hand_on_seven_cent_coin:
		if denomination_in_hand == 0:
			$"../CoinPurse/Area2D/7coin".offset.y = 0
			$"../CoinPurse/Area2D/7coin".global_position = lerp($"../CoinPurse/Area2D/7coin".global_position, get_global_mouse_position() + Vector2(6, 12), 0.2)
		if denomination_in_hand == 7:
			$"../CoinPurse/Area2D/7coin".global_position = coin1_home
			$"../CoinPurse/Area2D/7coin".visible = false
	else:
		$"../CoinPurse/Area2D/7coin".global_position = lerp($"../CoinPurse/Area2D/7coin".global_position, coin7_home, 0.2)
	cursor_speed = cursor_position_last_frame.distance_to(get_global_mouse_position())
	
	# grabbing the crank or holding coin
	if mouse_held_down or holding_coin:
		frame = 2
	# pointing at screen or finger over the button
	elif can_tap or can_stop:
		frame = 1
	# open hand
	else:
		frame = 0
	
	if Input.is_action_just_pressed("click"):
		if hand_on_one_cent_coin:
			grab_coin(1)
		elif hand_on_three_cent_coin:
			grab_coin(5)
		elif hand_on_seven_cent_coin:
			grab_coin(7)
		# mouse inside interaction area
		if mouse_inside:
			mouse_held_down = true
		# tap on the screen or the button
		# (tapping on the screen does nothing intentionally)
		if can_tap or can_stop:
			get_node("AnimationPlayer").play("tap")
			get_node("AnimationPlayer").seek(0)
	# make the button out
	$"../SlotMachine/Button/Sprite2D".frame = 0
	if can_stop:
		# if our hand is in the stop area and we click
		if Input.is_action_pressed("click"):
			# hold button down
			$"../SlotMachine/Button/Sprite2D".frame = 1
		if Input.is_action_just_pressed("click"):
			# stop the next spinner
			get_parent().stop_spinners()
	
	# this is to release the crank
	if Input.is_action_just_released("click"):
		if holding_coin:
			if hovering_coin_mechanism:
				if denomination_in_hand == 7:
					$"../SlotMachine/coinanimation/1coin".visible = false
					$"../SlotMachine/coinanimation/3coin".visible = false
					$"../SlotMachine/coinanimation/7coin".visible = true
					insert_coin(7)
				if denomination_in_hand == 5:
					$"../SlotMachine/coinanimation/1coin".visible = false
					$"../SlotMachine/coinanimation/3coin".visible = true
					$"../SlotMachine/coinanimation/7coin".visible = false
					insert_coin(5)
				if denomination_in_hand == 1:
					$"../SlotMachine/coinanimation/1coin".visible = true
					$"../SlotMachine/coinanimation/3coin".visible = false
					$"../SlotMachine/coinanimation/7coin".visible = false
					insert_coin(1)
			else:
				drop_coin()
		mouse_held_down = false
	
	global_position = get_global_mouse_position()
	cursor_position_last_frame = get_global_mouse_position()

func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true

func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false

# this is for when youre holding the crank and you pull down
# the pulling animation changes with the speed at which your mouse moves
func _on_pull_area_mouse_entered() -> void:
	if mouse_held_down:
		mouse_held_down = false
		get_node("../AnimationPlayer").speed_scale = clamp(cursor_speed/10, 1, 20)
		$"../CrankSfx".pitch_scale = 0.8 + (clamp(cursor_speed/10, 1, 20) - 1) * (1.2 - 0.8) / (20 - 1)
		if get_parent().plays == 0:
			get_node("../AnimationPlayer").play("no_money_crank")
		if get_parent().plays > 0 and get_parent().is_any_spinning():
			get_node("../AnimationPlayer").play("empty_crank")
		elif get_parent().plays > 0 and not get_parent().is_any_spinning():
			get_parent().jackpot += get_parent().plays
			get_parent().plays -= 1
			# 80% chance to "almost win" on the 2nd to last roll
			# to incentivize the player to keep gambling
			if (get_parent().plays == 0 and Global.money < 10 and Global.money >= 5) or (get_parent().plays == 1 and Global.money < 5):
				var rand: int = randi_range(0, 9)
				print("might edge or disappoint")
				if rand <= 3:
					print("disappoint")
					get_parent().disappoint = true
				elif rand <= 7:
					print("edge")
					get_parent().edge = true
			# 50% chance to have a forced win on your last spin
			elif get_parent().plays == 0 and Global.money < 5:
				print("might rig")
				if randi_range(0, 1) == 1:
					print("its rigged")
					get_parent().is_rigged = true
			else:
				get_parent().disappoint = false
				get_parent().edge = false
				get_parent().is_rigged = false
			print(get_parent().is_rigged)
			get_node("../AnimationPlayer").play("crank")
			# normalize between .8 and 1.2

func _on_cancel_area_mouse_exited() -> void:
	mouse_inside = false
	mouse_held_down = false

func _on_tap_area_mouse_entered() -> void:
	can_tap = true

func _on_tap_area_mouse_exited() -> void:
	can_tap = false

func _on_stopbutton_area_2d_mouse_entered() -> void:
	can_stop = true

func _on_stopbutton_area_2d_mouse_exited() -> void:
	can_stop = false

func grab_coin(denomination: int) -> void:
	holding_coin = true
	if denomination == 1:
		denomination_in_hand = 1
		$Coin1Sprite.visible = true
	elif denomination == 5:
		denomination_in_hand = 5
		$Coin3Sprite.visible = true
	elif denomination == 7:
		denomination_in_hand = 7
		$Coin7Sprite.visible = true

func drop_coin() -> void:
	denomination_in_hand = 0
	holding_coin = false
	$Coin1Sprite.visible = false
	$Coin3Sprite.visible = false
	$Coin7Sprite.visible = false

func _on_coinmechanism_mouse_entered() -> void:
	hovering_coin_mechanism = true

func _on_coinmechanism_mouse_exited() -> void:
	hovering_coin_mechanism = false

func insert_coin(amount) -> void:
	holding_coin = false
	$Coin1Sprite.visible = false
	$Coin3Sprite.visible = false
	$Coin7Sprite.visible = false
	if Global.money >= amount:
		Global.money -= amount
		$"../SlotMachine/coinanimation/CoinInsertAnimationPlayer".play("insertcoin")
		$"../SlotMachine/coinanimation/CoinInsertAnimationPlayer".seek(0)
		get_parent().plays += 1
		denomination_in_hand = 0


func _on_coinpurse7_mouse_entered() -> void:
	hand_on_seven_cent_coin = true

func _on_coinpurse7_mouse_exited() -> void:
	hand_on_seven_cent_coin = false

func _on_coinpurse3_mouse_entered() -> void:
	hand_on_three_cent_coin = true

func _on_coinpurse3_mouse_exited() -> void:
	hand_on_three_cent_coin = false

func _on_coinpurse1_mouse_entered() -> void:
	hand_on_one_cent_coin = true

func _on_coinpurse1_mouse_exited() -> void:
	hand_on_one_cent_coin = false
