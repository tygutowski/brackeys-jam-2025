extends Node2D

# this is the "correct" index of the winnings.
# they are offset on the screen, so its a little confusing
var icons: Array[String] = [
	"seven","lemon","diamond","biscuit","horseshoe",
	"heart","clover","melon","cherry","bar"
]

@export var normal_speed: float = 180.0
@export var cell_px: int = 16
@export var slow_down_time: float = 0.6
@export var snap_time: float = 0.25

var spinning: bool = false
var speed: float = 0.0
var reel_offset: float = 0.0
var is_stopped: bool = true

# we have 2 wheels, so when 1 goes off screen, it resets above
# the other wheeel, as to give the illusion of a circular/infinite wheel
@onready var wheel_a: Sprite2D = $"Sprite2D"
@onready var wheel_b: Sprite2D = $"Sprite2D2"
var wheel_height: int = 0
func _ready() -> void:
	speed = 0.0
	reel_offset = 0.0
	is_stopped = true
	wheel_height = int(wheel_a.texture.get_size().y)
	offset(wheel_a.texture.get_size().y)

# spin the wheel based off the speed
func _process(delta: float) -> void:
	if wheel_height <= 0.0:
		return
	reel_offset += speed * delta
	offset(wheel_height)

# start the wheel
func start() -> void:
	is_stopped = false
	var start_tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var target_speed: float = normal_speed + randf_range(-30.0, 30.0)
	start_tween.tween_property(self, "speed", target_speed, 0.5)
	await start_tween.finished
	spinning = true
	
# stop the wheel
@warning_ignore("integer_division") # yeah no shit
func stop(desired_index: int = -1) -> int:
	spinning = false
	is_stopped = true
	speed = 0.0

	var cells: int = max(1, wheel_height / cell_px)
	var cur_cell: int = int(floor(reel_offset / float(cell_px)))

	var target_cell: int
	
	# this keeps rotating the wheel until the "desired index"
	# is being hovered. this is for rigging the machine
	if desired_index >= 0:
		var di: int = desired_index % cells
		var cur_mod: int = cur_cell % cells
		var delta: int = (di - cur_mod + cells) % cells
		target_cell = cur_cell + delta
	# this stops the wheel normally. used for the first roll
	# (1st roll is a gem, then we can rig roll 2 and 3 to be gems)
	else:
		var rem: int = int(reel_offset) % cell_px
		if rem == 0:
			target_cell = cur_cell
		else:
			target_cell = cur_cell + 1

	var target_off: float = float(target_cell * cell_px)
	while target_off < reel_offset:
		target_off += wheel_height

	var distance: float = target_off - reel_offset

	if distance < 0.0:
		distance += wheel_height  # just in case

	# how fast the wheel stops
	var time_per_px: float = 0.002
	var duration: float = distance * time_per_px
	# make sure its not too long or short
	duration = clamp(duration, 0.25, 1.0)

	var stop_tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	stop_tween.tween_property(self, "reel_offset", target_off, duration)
	await stop_tween.finished

	reel_offset = fposmod(reel_offset, wheel_height)
	offset(wheel_height)

	var landed: int = int(floor(reel_offset / float(cell_px))) % cells
	return landed

func offset(pos: float) -> void:
	var base: float = fposmod(reel_offset, pos)
	if wheel_a != null:
		wheel_a.offset.y = base
	if wheel_b != null:
		wheel_b.offset.y = base - pos
