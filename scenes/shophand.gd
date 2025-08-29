extends Sprite2D

var can_tap: bool = false
var item = null
@export var player: Player
var tickle_counter: int = 0
var tickle_time_decay: float = 10
var timer: float = 0
@onready var tickles_to_laugh: int = randi_range(3, 5)
func _process(delta: float) -> void:
	if timer > 0:
		timer = max(timer - delta, 0)
	elif timer == 0:
		tickle_counter = 0
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("click"):
		if can_tap:
			$AnimationPlayer.play("tap")
			timer = tickle_time_decay
			tickle_counter += 1
			if tickle_counter >= tickles_to_laugh:
				$"../WaltAnimationPlayer".play("giggle")
				tickle_counter = 0
		if item != null:
			if item.prereq != null and not item.prereq.bought:
				item.cantafford()
			elif Global.money >= item.price:
				Global.money -= item.price
				player.unlock_item(item.unlock_method_name)
				item.buy()
			else:
				item.cantafford()

func _on_taparea_mouse_entered() -> void:
	can_tap = true

func _on_taparea_mouse_exited() -> void:
	can_tap = false
