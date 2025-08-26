extends Node2D

# if the player is within interaction range of the slot machine
@export var occupied: bool = false
var player_in_area: bool = false
var animation_timer: float = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if occupied:
		return
	if body is Player:
		player_in_area = true
		body.within_slot_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if occupied:
		return
	if body is Player:
		player_in_area = false
		body.within_slot_range = false

# passive animations, might get rid of later.
func _process(delta: float) -> void:
	if occupied:
		if animation_timer <= 0:
			get_node("AnimationPlayer").play("crank")
			animation_timer = randf_range(0, 10)
		animation_timer -= delta
