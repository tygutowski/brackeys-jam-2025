extends CanvasLayer

var timer: float = 0
var anim_list: Array = ["blink", "move_eyes", "smile"]
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
	var anim_player: AnimationPlayer = $WaltAnimationPlayer

	anim_player.play(anim_list[randi() % anim_list.size()])

func pick_random_hat() -> void:
	for child in $Walt.get_child(0).get_children():
		child.visible = false
	var rand = randi_range(0, $Walt.get_child(0).get_child_count() - 1)
	$Walt.get_child(0).get_child(rand).visible = true
