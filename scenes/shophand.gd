extends Sprite2D

var can_tap: bool = false
var item = null
@export var player: Player

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("click"):
		if can_tap:
			$AnimationPlayer.play("tap")
		if item != null:
			if Global.money >= item.price:
				Global.money -= item.price
				player.unlock_item(item.unlock_method_name)
				item.buy()
			else:
				item.cantafford()

func _on_taparea_mouse_entered() -> void:
	can_tap = true

func _on_taparea_mouse_exited() -> void:
	can_tap = false
