extends Area2D
class_name Car

const ACCELERATION = 50
const DECELERATION = 100
const SPEED_LIMIT = 100
const MIN_VELOCITY = 0.1
var going_down: bool = false
var velocity: float
var drive: bool = false

func _ready() -> void:
	velocity = SPEED_LIMIT * randf_range(0.9, 1.1)
	drive = true

func _physics_process(delta: float) -> void:
	if going_down:
		position.y += velocity * delta
	else:
		position.y -= velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hit_by_car(self, going_down)
