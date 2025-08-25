extends CharacterBody2D
class_name Player

var room_offset = {
	"outside": Vector2(192, 152),
	"bakery": Vector2(544, 152),
	"casino": Vector2(192, 424),
	"shop": Vector2(544, 424),
}
@export var camera: Camera2D

var base_movement_speed: float = 80.0
var movement_speed: float

func _ready() -> void:
	camera.global_position = room_offset["bakery"]

func _physics_process(delta: float) -> void:
	movement_speed = base_movement_speed
	var input: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = input * movement_speed
	move_and_slide()

func teleport_to(target: Vector2, room_name: String) -> void:
	camera.global_position = room_offset[room_name]
	global_position = target
