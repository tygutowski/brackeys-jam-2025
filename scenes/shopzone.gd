extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.within_shop_range = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.within_shop_range = false
