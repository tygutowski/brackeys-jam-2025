extends CharacterBody2D
class_name Player

@export var outside: Node2D
@export var bakery: Node2D
@export var casino: Node2D
@export var shop: Node2D


var ingredient_price: int = 0
@onready var mixer = $"../../Bakery/MixerArea"
@onready var register = $"../../Bakery/RegisterArea"
@onready var oven = $"../../Bakery/OvenArea"
@onready var cutter = $"../../Bakery/CuttingArea"
@onready var fridge = $"../../Bakery/FridgeArea"
var shop_area: Area2D = null
var within_shop_range: bool = false
var t: Timer = null
@export var camera: Camera2D
@export var slot_machine_hud: CanvasLayer
var base_movement_speed: float = 80.0
var movement_speed: float

@export var empty_icon: Texture2D
@export var ingredients_icon: Texture2D
@export var dough_icon: Texture2D
@export var raw_icon: Texture2D
@export var cooked_icon: Texture2D
@export var overcooked_icon: Texture2D
@export var burnt_icon: Texture2D

var has_timbs: bool = false # runs faster
var has_pager: bool = false # pages when customer enters
var has_doughbot: bool = false # automatically mixes and portions dough
var has_cool_hat # unlocks vip lounge
var has_cranker # cranks slot machine a few times while you're gone
var has_funnel: bool = false # automagically puts plays into machine
var has_conveyor: bool = false # moves ingredients from one place to another
var has_fancy_oven: bool = false # automatically cooks food

@export var shop_hud: CanvasLayer
var customer_stack: Array = []
var held_biscuit: Biscuit = null
var toasting: bool = false
# if youre within range of a slot machine
var within_slot_range: bool = false

var in_register_area: bool = false
var in_oven_area: bool = false
var in_mixer_area: bool = false
var in_cutting_area: bool = false
var in_garbage_area: bool = false
var in_fridge_area: bool = false

var in_placement1_area: bool = false
var in_placement2_area: bool = false
var in_placement3_area: bool = false
var place1_item: Biscuit = null
var place2_item: Biscuit = null
var place3_item: Biscuit = null

func get_timbs() -> void:
	has_timbs = true
	
func get_pager() -> void:
	has_pager = true
	
func get_doughbot() -> void:
	has_doughbot = true
	
func get_cool_hat() -> void:
	has_cool_hat = true
	
func get_cranker() -> void:
	has_cranker = true
	 
func get_funnel() -> void:
	has_funnel = true
	
func get_conveyor() -> void:
	has_conveyor = true
	
func get_fancy_oven() -> void:
	has_fancy_oven = true
	

func _ready() -> void:
	slot_machine_hud.visible = false
	camera.global_position = bakery.camera_pos
	outside.exited()
	shop.exited()
	casino.exited()
	bakery.entered()

func unlock_item(variable_name: String) -> void:
	var variable = get(variable_name)
	variable = true

func _physics_process(_delta: float) -> void:
	# if youre within range of slot machines
	# then you can access them

	if Input.is_action_just_pressed("interact"):
		if within_slot_range:
			open_slot_machine()
		if within_shop_range:
			open_shop()
		if in_register_area:
			use_register()
		if in_oven_area:
			use_oven()
		if in_cutting_area:
			use_cutter()
		if in_mixer_area:
			use_mixer()
		if in_garbage_area:
			throw_away()
		if in_fridge_area:
			use_fridge()
		if in_placement1_area:
			place(1)
		if in_placement2_area:
			place(2)
		if in_placement3_area:
			place(3)
	if not toasting:
		if within_shop_range and not shop_hud.visible:
			$"../../../UI/InteractPrompt".text = "Open shop"
		elif within_slot_range and not slot_machine_hud.visible:
			$"../../../UI/InteractPrompt".text = "Play slots"
		elif in_cutting_area:
			if cutter.item_in_cutter:
				if cutter.biscuit.stage == cutter.biscuit.stageEnum.SHAPED:
					$"../../../UI/InteractPrompt".text = "Take dough"
				elif cutter.biscuit.stage == cutter.biscuit.stageEnum.RAW and cutter.in_use:
					$"../../../UI/InteractPrompt".text = "Portioning dough"
				elif cutter.biscuit.stage == cutter.biscuit.stageEnum.RAW and not cutter.in_use:
					$"../../../UI/InteractPrompt".text = "Continue portioning dough"
			elif not cutter.item_in_cutter or cutter.item_in_cutter and not cutter.in_use:
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
					$"../../../UI/InteractPrompt".text = "Make dough"
		elif in_oven_area:
			if oven.item_in_oven:
				$"../../../UI/InteractPrompt".text = "Take biscuits out"
			else:
				$"../../../UI/InteractPrompt".text = "Put biscuits in"
		elif in_garbage_area:
			$"../../../UI/InteractPrompt".text = "Throw away"
		elif in_fridge_area:
			$"../../../UI/InteractPrompt".text = "Get ingredients"
		elif in_placement1_area:
			if place1_item == null:
				if held_biscuit == null:
					$"../../../UI/InteractPrompt".text = ""
				else:
					$"../../../UI/InteractPrompt".text = "Place item"
			else:
				if held_biscuit == null:
					$"../../../UI/InteractPrompt".text = "Pick up item"
				else:
					$"../../../UI/InteractPrompt".text = "Swap items"
		elif in_placement2_area:
			if place2_item == null:
				if held_biscuit == null:
					$"../../../UI/InteractPrompt".text = ""
				else:
					$"../../../UI/InteractPrompt".text = "Place item"
			else:
				if held_biscuit == null:
					$"../../../UI/InteractPrompt".text = "Pick up item"
				else:
					$"../../../UI/InteractPrompt".text = "Swap items"
		elif in_placement3_area:
			if place3_item == null:
				if held_biscuit == null:
					$"../../../UI/InteractPrompt".text = ""
				else:
					$"../../../UI/InteractPrompt".text = "Place item"
			else:
				if held_biscuit == null:
					$"../../../UI/InteractPrompt".text = "Pick up item"
				else:
					$"../../../UI/InteractPrompt".text = "Swap items"
		else:
			$"../../../UI/InteractPrompt".text = ""
	# movement logic. i use base_movement_speed in case we
	# add boots or movement speed upgrades later
	movement_speed = base_movement_speed
	if has_timbs:
		movement_speed + 15.0
	var input: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = input * movement_speed
	# close slots/shop/etc
	if Input.is_action_just_pressed("close"):
		close_all_huds()
	if velocity.x > 0:
		get_node("Sprite2D").flip_h = false
		$TinyHands.flip_h = false
	elif velocity.x < 0:
		get_node("Sprite2D").flip_h = true
		$TinyHands.flip_h = true
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
	if slot_machine_hud.visible:
		return
	slot_machine_hud.visible = true

func open_shop() -> void:
	if shop_hud.visible:
		return
	shop_hud.pick_random_hat()
	shop_hud.visible = true

func close_all_huds() -> void:
	slot_machine_hud.visible = false
	shop_hud.visible = false
	
func _on_cutting_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_cutting_area = false
		cutter.pause_shaping_dough()

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
	if cutter.item_in_cutter:
		# 1a) SHAPED in tray -> Take dough
		if cutter.biscuit.stage == held_biscuit.stageEnum.SHAPED:
			if held_biscuit == null:
				held_biscuit = cutter.get_biscuit() # take shaped dough
				update_hand()
			else:
				toast("Your hands are full")
			return
		if cutter.in_use:
			toast("You are already shaping the dough")
			return

		if cutter.biscuit.stageEnum.RAW:
			if held_biscuit == null:
				print("start shaping existing dough")
				cutter.shape_dough()
				return
			else:
				toast("The tray is already occupied")
				return

	if held_biscuit == null:
		toast("You don't have any dough. Try mixing up a batch")
		return

	match held_biscuit.stage:
		held_biscuit.stageEnum.RAW:
			if cutter.in_use:
				toast("You are already shaping the dough")
			else:
				print("start shaping new dough")
				cutter.shape_dough(held_biscuit) # start portioning
				held_biscuit = null
				update_hand()
		held_biscuit.stageEnum.SHAPED:
			toast("This dough has already been shaped")
		held_biscuit.stageEnum.COOKED:
			toast("These biscuits are already cooked")
		held_biscuit.stageEnum.INGREDIENTS:
			toast("You can't shape ingredients, try mixing it into dough first")
	
func use_register() -> void:
	if held_biscuit == null:
		toast("You aren't holding anything")
		return

	match held_biscuit.stage:
		held_biscuit.stageEnum.INGREDIENTS:
			toast("You can't sell raw ingredients to customers")
			return
		held_biscuit.stageEnum.RAW, held_biscuit.stageEnum.SHAPED:
			toast("You can't sell dough to customers")
			return
		held_biscuit.stageEnum.COOKED:
			if held_biscuit.quality < 0.4:
				toast("These biscuits are raw, put them back in the oven")
				return
			if customer_stack.is_empty():
				toast("There are no customers to buy your biscuits")
				return
			register.cash_out(held_biscuit)
			held_biscuit = null
			update_hand()


func use_fridge() -> void:
	if held_biscuit == null:
		if Global.money >= ingredient_price:
			Global.money -= ingredient_price
			held_biscuit = fridge.get_biscuit()
		else:
			toast("The ingredients cost {0} coins, but you only have {1}".format([ingredient_price, Global.money]))
	else:
		toast("Your hands are full")
	update_hand()
	
func use_mixer() -> void:
	if held_biscuit != null:
		if held_biscuit.stage == held_biscuit.stageEnum.INGREDIENTS:
			if mixer.item_in_mixer:
				if mixer.in_use:
					toast("The mixer is already being used")
			else:
				mixer.start_mixer(held_biscuit)
				held_biscuit = null
		else:
			toast("You must put raw ingredients into the mixer")
	else:
		if mixer.item_in_mixer:
			if mixer.in_use:
				toast("The mixer is already being used")
			else:
				held_biscuit = mixer.get_biscuit()
		else:
			toast("You don't have any ingredients. Try getting some from the fridge")
	update_hand()
	
func use_oven() -> void:
	if oven.item_in_oven:
		if held_biscuit == null:
			held_biscuit = oven.get_biscuit()
			return
		else:
			toast("There's already something in the oven")
	else:
		if held_biscuit != null:
			# if we have a shaped biscuit
			if held_biscuit.stage == held_biscuit.stageEnum.SHAPED or held_biscuit.stage == held_biscuit.stageEnum.COOKED:
				oven.cook_biscuit(held_biscuit)
				held_biscuit = null
			elif held_biscuit.stage == held_biscuit.stageEnum.RAW:
				toast("It's just a big wad of dough, shape it into biscuits first")
			elif held_biscuit.stage == held_biscuit.stageEnum.INGREDIENTS:
				toast("You can't cook raw ingredients, mix it into dough first")
		else:
			toast("You aren't holding anything")
	update_hand()
	
func throw_away() -> void:
	if held_biscuit == null:
		toast("You don't have anything to throw away")
	held_biscuit = null
	update_hand()
	
func _on_garbage_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_garbage_area = true

func _on_garbage_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_garbage_area = false

func toast(text, duration: float = 3) -> void:
	if t != null:
		t.queue_free()
	toasting = true
	t = Timer.new()
	add_child(t)
	t.start(duration)
	$"../../../UI/InteractPrompt".text = text
	await t.timeout
	toasting = false

func _on_fridge_area_body_entered(body: Node2D) -> void:
	in_fridge_area = true

func _on_fridge_area_body_exited(body: Node2D) -> void:
	in_fridge_area = false


func _on_placement_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_placement1_area = true

func _on_placement_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_placement1_area = false


func _on_placement_2_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_placement2_area = true


func _on_placement_2_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_placement2_area = false


func _on_placement_3_area_body_entered(body: Node2D) -> void:
	if body is Player:
		in_placement3_area = true


func _on_placement_3_area_body_exited(body: Node2D) -> void:
	if body is Player:
		in_placement3_area = false

func place(zone: int) -> void:
	var slot: Biscuit = _get_place_item(zone)

	if slot == null and held_biscuit != null:
		_set_place_item(zone, held_biscuit)
		held_biscuit = null
	elif slot != null and held_biscuit == null:
		held_biscuit = slot
		_set_place_item(zone, null)
	elif slot != null and held_biscuit != null:
		# swap
		_set_place_item(zone, held_biscuit)
		held_biscuit = slot

	set_place_item(zone)  # update sprite
	update_hand()


func _get_place_item(zone: int):
	match zone:
		1: return place1_item
		2: return place2_item
		3: return place3_item
		_: return null

func _set_place_item(zone: int, v):
	match zone:
		1: place1_item = v
		2: place2_item = v
		3: place3_item = v


func set_place_item(zone: int) -> void:
	var item_sprite: Sprite2D
	var item

	match zone:
		1:
			item = place1_item
			item_sprite = $"../../Bakery/Placement1Area/Item"
		2:
			item = place2_item
			item_sprite = $"../../Bakery/Placement2Area/Item"
		3:
			item = place3_item
			item_sprite = $"../../Bakery/Placement3Area/Item"

	if item == null:
		item_sprite.texture = empty_icon
		return

	# Use the slot item (not held_biscuit)
	match item.stage:
		item.stageEnum.INGREDIENTS:
			item_sprite.texture = ingredients_icon
		item.stageEnum.RAW:
			item_sprite.texture = dough_icon
		item.stageEnum.SHAPED:
			item_sprite.texture = raw_icon
		item.stageEnum.COOKED:
			match item.cook_amount:
				2: item_sprite.texture = raw_icon          # undercooked
				3: item_sprite.texture = cooked_icon       # cooked
				6: item_sprite.texture = overcooked_icon   # overcooked
				4: item_sprite.texture = burnt_icon        # burnt
				_: item_sprite.texture = cooked_icon


func update_hand() -> void:
	if held_biscuit == null:
		$TinyHands.frame = 0
	else:
		if held_biscuit.stage == held_biscuit.stageEnum.INGREDIENTS:
			$TinyHands.frame = 7
		elif held_biscuit.stage == held_biscuit.stageEnum.RAW:
			$TinyHands.frame = 1
		elif held_biscuit.stage == held_biscuit.stageEnum.SHAPED:
			$TinyHands.frame = 2
		elif held_biscuit.stage == held_biscuit.stageEnum.COOKED:
			$TinyHands.frame = held_biscuit.cook_amount


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
