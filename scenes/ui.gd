extends CanvasLayer

var timer: float = 0
var accelerator: float = 0
var money_counter: int = 0
var money_counter_total: int = -1
func _process(delta: float) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Label.text = str(Global.money)
	if is_inf(timer):
		timer = 0
	if timer <= 0:
		if money_counter > 0:
			Global.money += 1
			money_counter -= 1
			
			var k := 0.90
			var progress := float(money_counter_total - money_counter) / money_counter_total
			timer = (progress * k + 1.0)/money_counter
		else:
			timer = 0
	timer -= delta

func increase_money(value: int) -> void:
	money_counter += value
	money_counter_total += value
