extends Node2D

var customer_scene: PackedScene = preload("res://scenes/Customer.tscn")

@export var left_region: NavigationRegion2D
@export var left_customers: Array[Customer]
@export var right_region: NavigationRegion2D
@export var right_customers: Array[Customer]

func _physics_process(delta: float) -> void:
	for customer in left_customers:
		if customer.navigation_agent.is_navigation_finished():
			customer.set_target(NavigationServer2D.region_get_random_point(left_region.get_region_rid(), 1, false))
	for customer in right_customers:
		if customer.navigation_agent.is_navigation_finished():
			customer.set_target(NavigationServer2D.region_get_random_point(right_region.get_region_rid(), 1, false))
