extends Area2D
class_name Car

const ACCELERATION = 50
const DECELERATION = 100
const SPEED_LIMIT = 100
const MIN_VELOCITY = 0.1

var velocity: float
var drive: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = SPEED_LIMIT
	drive = true

func _physics_process(delta: float) -> void:
	# SLOW DOWN
	if (not drive):
		if (velocity < MIN_VELOCITY):
			velocity = 0
		else:
			velocity -= DECELERATION * delta
	# SPEED UP
	else:
		if (velocity > SPEED_LIMIT):
			velocity = SPEED_LIMIT
		else:
			velocity += ACCELERATION * delta
	position.y -= velocity * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_accept")):
		if drive:
			drive = false
		else:
			drive = true

func _on_area_exited(area: Area2D) -> void:
	drive = true

func _on_area_entered(area: Area2D) -> void:
	if area.name == "StoppingDistance":
		drive = false
