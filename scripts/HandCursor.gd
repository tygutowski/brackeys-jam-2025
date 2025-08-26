extends Sprite2D

var mouse_inside: bool = false
var mouse_held_down: bool = false
var cranking: bool = false
var cursor_speed: float = 0
var cursor_position_last_frame: Vector2
var can_tap: bool = false
var can_stop: bool = false

func _ready() -> void:
	cursor_position_last_frame = get_global_mouse_position()

func _process(_delta: float) -> void:
	cursor_speed = cursor_position_last_frame.distance_to(get_global_mouse_position())
	
	# pointing at screen or finger over the button
	if can_tap or can_stop:
		frame = 1
	# grabbing the crank
	elif mouse_held_down:
		frame = 2
	# open hand
	else:
		frame = 0
	
	if Input.is_action_just_pressed("click"):
		# mouse inside interaction area
		if mouse_inside:
			mouse_held_down = true
		# tap on the screen or the button
		# (tapping on the screen does nothing intentionally)
		if can_tap or can_stop:
			get_node("AnimationPlayer").play("tap")
			get_node("AnimationPlayer").seek(0)
	# make the button out
	$"../Area2D/Sprite2D".frame = 0
	if can_stop:
		# if our hand is in the stop area and we click
		if Input.is_action_pressed("click"):
			# hold button down
			$"../Area2D/Sprite2D".frame = 1
		if Input.is_action_just_pressed("click"):
			# stop the next spinner
			get_parent().stop_spinners()
	
	# this is to release the crank
	if Input.is_action_just_released("click"):
		mouse_held_down = false
	
	global_position = get_global_mouse_position()
	cursor_position_last_frame = get_global_mouse_position()

func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true

func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false

# this is for when youre holding the crank and you pull down
# the pulling animation changes with the speed at which your mouse moves
func _on_pull_area_mouse_entered() -> void:
	if mouse_held_down:
		mouse_held_down = false
		get_node("../AnimationPlayer").speed_scale = clamp(cursor_speed/10, 1, 20)
		get_node("../AnimationPlayer").play("crank")

func _on_cancel_area_mouse_exited() -> void:
	mouse_inside = false
	mouse_held_down = false

func _on_tap_area_mouse_entered() -> void:
	can_tap = true

func _on_tap_area_mouse_exited() -> void:
	can_tap = false

func _on_stopbutton_area_2d_mouse_entered() -> void:
	can_stop = true

func _on_stopbutton_area_2d_mouse_exited() -> void:
	can_stop = false
