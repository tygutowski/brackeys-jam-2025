extends Sprite2D

@export var unlock_method_name: String
@onready var player: Player = $"../../../World/Generic/CharacterBody2D"
@export var price: int
var bought: bool = false
@export var prereq: Sprite2D
@export var itemname: String = "item"
@export var description: String = "description"

func _ready() -> void:
	var shape: Shape2D = $Area2D/CollisionShape2D.shape
	shape.size = Vector2(texture.get_size())
	get_node("outline").texture = texture

func hover_item(value: bool) -> void:
	if value:
		var item: String = str(itemname)
		var desc: String = str(description)
		var price: String = str(price)
		player.toast("{0} coins: {1}\n{2}".format([price, item, desc]), 1000)
		get_node("outline").visible = true
		$"../../Hand".item = self
	else:
		$"../../Hand".item = null
		player.toast("", 0.01)
		get_node("outline").visible = false

func buy() -> void:
	bought = true
	$AudioStreamPlayer.play()
	visible = false
	get_node("Area2D").monitoring = false
	get_node("Area2D").monitorable = false

func cantafford() -> void:
	$CantAfford.play()

func _on_area_2d_mouse_entered() -> void:
	hover_item(true)

func _on_area_2d_mouse_exited() -> void:
	hover_item(false)
