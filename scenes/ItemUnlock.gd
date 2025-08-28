extends Area2D

@export var variable_name: String
@export var player: Player
@export var price: int

@export var itemname: String = "item"
@export var description: String = "description"

func _ready() -> void:
	get_node("CollisionShape2D").disabled = false

func buy() -> void:
	if Global.money >= price:
		visible = false
		Global.money -= price
		player.unlock_item(variable_name)
		get_node("MoneyNoise").play()
		get_node("CollisionShape2D").disabled = true
	else:
		get_node("BrokeNoise").play()
	
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player.shop_area = null
		
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player.shop_area = self
