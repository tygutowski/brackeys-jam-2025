extends CanvasLayer

var timer: float = 0

func _ready() -> void:
	return
	visible = false

func _process(delta: float) -> void:
	if not visible:
		return
	if timer <= 0:
		timer = randf_range(10, 15)
		walt_do_something()
	timer -= delta

func walt_do_something() -> void:
	print("walt do something")
	var anim_player: AnimationPlayer = $WaltAnimationPlayer
	var list = anim_player.get_animation_list()
	anim_player.play(list[randi() % list.size()])

func pick_random_hat() -> void:
	for child in $Walt.get_child(0).get_children():
		child.visible = false
	var rand = randi_range(0, $Walt.get_child(0).get_child_count() - 1)
	$Walt.get_child(0).get_child(rand).visible = true
