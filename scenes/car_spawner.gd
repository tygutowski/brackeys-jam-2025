extends Node2D

var timer: float = 0
@export var car_scene: PackedScene
@export var going_down: bool = false

@export var texture_list : Array[Texture]

func _process(delta: float) -> void:
	if timer <= 0:
		timer = randf_range(0.8, 1.5)
		spawn_car()
	timer -= delta

func spawn_car() -> void:
	var car = car_scene.instantiate()
	car.get_node("Sprite2D").texture = texture_list[randi_range(0,2)]
	if going_down:
		car.going_down = true
		car.get_node("Sprite2D").rotation = PI
	add_child(car)
