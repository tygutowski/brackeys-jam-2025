extends Node2D

# if the player is within interaction range of the slot machine
var player_in_area: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_area = true
		body.within_slot_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_area = false
		body.within_slot_range = false
