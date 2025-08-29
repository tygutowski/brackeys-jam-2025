extends Room

var camera_pos: Vector2 = Vector2(544, 152)
var customer_stack: Array = []


func _on_add_customer_timer_timeout() -> void:
	print("add customer")
	$Customer.set_target($Spot1.global_position)
	add_customer()

func add_customer():
	pass

func _process(delta: float) -> void:
	pass
