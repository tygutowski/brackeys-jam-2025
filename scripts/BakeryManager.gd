extends Room

@export var queue_slots: Array[Node2D] = []

var customer_scene: PackedScene = preload("res://scenes/Customer.tscn")
var camera_pos: Vector2 = Vector2(544, 152)
@export var customer_stack: Array[Customer] = []
@onready var max_customers: int = queue_slots.size()
var customer_spawn_time: float = 90
var customer_spawn_rand: float = 30 # customer_spawn_time + [0, this_value]

func _on_add_customer_timer_timeout() -> void:
	$AddCustomerTimer.start(customer_spawn_time + randf_range(0, customer_spawn_rand))
	if customer_stack.size() < max_customers:
		var current_customer: Customer = customer_scene.instantiate()
		customer_stack.append(current_customer)
		current_customer.global_position = $BakeryOutDoor.global_position
		
		add_child(current_customer)
		current_customer.movement_target_position = queue_slots[customer_stack.size()-1].global_position


func is_customer_at_register() -> bool:
	if customer_stack[0].navigation_agent.is_navigation_finished():
		return true
	else:
		return false

func remove_customer():
	customer_stack.pop_front().leave($BakeryOutDoor.global_position)
	for i in range(customer_stack.size()):
		customer_stack[i].set_target(queue_slots[i].global_position)
