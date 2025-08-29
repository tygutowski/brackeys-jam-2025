extends CharacterBody2D
class_name Customer

@onready var speed : float = randi_range(4,6)
@export var movement_target_position: Vector2
var player: Player = null

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
#var end_goal: Vector2 = starting_pos

var leaving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not movement_target_position:
		movement_target_position = global_position
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 1.0
	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	navigation_agent.target_position = movement_target_position

func _physics_process(_delta: float) -> void:
	if global_position.y <= player.global_position.y + 6:
		$Sprite2D.z_index = 0
	else:
		$Sprite2D.z_index = 1
	var direction : Vector2
	if navigation_agent.is_navigation_finished():
		direction = Vector2.ZERO
		if leaving:
			queue_free()
	else:
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		direction = current_agent_position.direction_to(next_path_position)
	
	velocity = direction * speed
	move_and_slide()

func set_target(goal: Vector2):
	#end_goal = goal
	navigation_agent.target_position = goal

func leave(goal: Vector2):
	navigation_agent.target_position = goal
	leaving = true
