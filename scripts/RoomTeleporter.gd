extends Area2D
class_name Door

@export_enum("outside", "bakery", "casino", "shop") var current_room: String
@export_enum("outside", "bakery", "casino", "shop") var new_room: String
@export var target_room: Door

func enterTeleporter(player) -> void:
	# teleport the player 16 pixels below the door (one tile)
	# so they dont instantly teleport back through
	var offset: Vector2
	if new_room == "outside":
		offset = Vector2(0, 16)
	else:
		offset  = Vector2(0, -20)
	var target: Vector2 = target_room.global_position + offset
	target_room.monitoring = false
	player.teleport_to(target, current_room, new_room)
	await get_tree().physics_frame
	target_room.monitoring = true
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		enterTeleporter(body)
