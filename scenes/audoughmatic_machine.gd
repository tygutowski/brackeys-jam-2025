extends Sprite2D

var biscuit: Biscuit = null
var on: bool = false
@export var fancyoven: Node2D

func _process(_delta) -> void:
	if not on and biscuit != null:
		if fancyoven != null and fancyoven.visible:
			if not fancyoven.on:
				fancyoven.cook()

func create_tray() -> void:
	on = false
	biscuit = Biscuit.new()
	biscuit.stage = biscuit.stageEnum.SHAPED
	$Output/CollisionShape2D.disabled = false
		
func grab_tray() -> Biscuit:
	var biscuit_to_return = biscuit
	biscuit = null
	$Node2D/Tray.visible = false
	$Output/CollisionShape2D.disabled = true
	$Input/CollisionShape2D.disabled = false
	return biscuit_to_return
	
func start() -> void:
	on = true
	$Input/CollisionShape2D.disabled = true
	$AnimationPlayer.play("make_dough")
