extends CharacterBody2D
class_name Player

@export var outside: Node2D
@export var bakery: Node2D
@export var casino: Node2D
@export var shop: Node2D

@export var camera: Camera2D
@export var slot_machine_hud: CanvasLayer
var base_movement_speed: float = 80.0
var movement_speed: float

# if youre within range of a slot machine
var within_slot_range: bool = false
var within_shop_range: bool = false

func _ready() -> void:
	slot_machine_hud.visible = false
	camera.global_position = casino.camera_pos
	outside.exited()
	shop.exited()
	bakery.exited()
	casino.entered()

func _physics_process(_delta: float) -> void:
	# if youre within range of slot machines
	# then you can access them
	if Input.is_action_just_pressed("interact"):
		if within_slot_range:
			open_slot_machine()
	
	# movement logic. i use base_movement_speed in case we
	# add boots or movement speed upgrades later
	movement_speed = base_movement_speed
	var input: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = input * movement_speed
	# close slots/shop/etc
	if Input.is_action_just_pressed("close"):
		close_all_huds()
	if velocity.x > 0:
		get_node("Sprite2D").flip_h = false
	elif velocity.x < 0:
		get_node("Sprite2D").flip_h = true
	if velocity.is_zero_approx():
		get_node("AnimationPlayer").play("idle")
	else:
		get_node("AnimationPlayer").play("run")
	move_and_slide()

# this is for movement between rooms
func teleport_to(target: Vector2, current_room_name: String, new_room_name: String) -> void:
	var new_room_scene = get(new_room_name)
	var current_room_scene = get(current_room_name)
	camera.global_position = new_room_scene.camera_pos
	global_position = target
	new_room_scene.entered()
	current_room_scene.exited()

func open_slot_machine() -> void:
	slot_machine_hud.visible = true

func close_all_huds() -> void:
	slot_machine_hud.visible = false
