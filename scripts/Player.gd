extends CharacterBody2D
class_name Player

@export var outside: Node2D
@export var bakery: Node2D
@export var casino: Node2D
@export var shop: Node2D

@onready var mixer = $"../../Bakery/MixerArea"
@onready var register = $"../../Bakery/RegisterArea"
@onready var oven = $"../../Bakery/OvenArea"
@onready var cutter = $"../../Bakery/CuttingArea"

@export var camera: Camera2D
@export var slot_machine_hud: CanvasLayer
var base_movement_speed: float = 80.0
var movement_speed: float

var customer_stack: Array = []
var inventory: Array[Biscuit] = []

# if youre within range of a slot machine
var within_slot_range: bool = false
var within_shop_range: bool = false

var in_register_area: bool = false
var in_oven_area: bool = false
var in_mixer_area: bool = false
var in_cutting_area: bool = false

func set_hints_visible(value: bool) -> void:
	$"../../Bakery/OvenArea/AnimatedSprite2D".visible = value
	$"../../Bakery/RegisterArea/AnimatedSprite2D2".visible = value
	$"../../Bakery/MixerArea/AnimatedSprite2D4".visible = value
	$"../../Bakery/CuttingArea/AnimatedSprite2D3".visible = value

func _ready() -> void:
	set_hints_visible(true)
	slot_machine_hud.visible = false
	camera.global_position = bakery.camera_pos
	outside.exited()
	shop.exited()
	casino.exited()
	bakery.entered()

func _physics_process(_delta: float) -> void:
	# if youre within range of slot machines
	# then you can access them
	if Input.is_action_just_pressed("interact"):
		if within_slot_range:
			open_slot_machine()
		if in_mixer_area:
			use_mixer()
		if in_cutting_area:
			use_cutter()
		if in_oven_area:
			use_oven()
		if in_register_area:
			use_register()

	if in_cutting_area:
		$"../../../UI/InteractPrompt".text = "Portion dough"
	elif in_register_area:
		$"../../../UI/InteractPrompt".text = "Use register"
	elif in_mixer_area:
		if mixer.in_use:
			$"../../../UI/InteractPrompt".text = mixer.get_time_left()
		else:
			if mixer.item_in_mixer:
				$"../../../UI/InteractPrompt".text = "Take dough"
			else:
				$"../../../UI/InteractPrompt".text = "Mix dough"
	elif in_oven_area:
		$"../../../UI/InteractPrompt".text = "Cook biscuits"
	else:
		$"../../../UI/InteractPrompt".text = ""
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

func _on_cutting_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_cutting_area = false

func _on_cutting_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_cutting_area = true

func _on_mixer_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_mixer_area = true

func _on_mixer_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_mixer_area = false

func _on_register_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_register_area = true

func _on_register_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_register_area = false

func _on_oven_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_oven_area = true

func _on_oven_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_oven_area = false

func use_cutter() -> void:
	for biscuit in inventory:
		if biscuit.stage == biscuit.stageEnum.RAW:
			cutter.shape_dough(biscuit)
			
func use_register() -> void:
	if customer_stack.size() > 0:
		for biscuit in inventory:
			if biscuit.stage == biscuit.stageEnum.RAW:
				register.cash_out(biscuit)

func use_mixer() -> void:
	if mixer.item_in_mixer:
		if mixer.in_use:
			return
		else:
			var biscuit = mixer.get_biscuit()
			assert(biscuit != null)
			inventory.append(biscuit)
	else:
		mixer.start_mixer()

func use_oven() -> void:
	for biscuit in inventory:
		if biscuit.stage == biscuit.stageEnum.SHAPED:
			oven.cook_biscuit(biscuit)
