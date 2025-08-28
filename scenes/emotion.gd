extends TextureRect

@export var joyous: Texture = null
@export var happy: Texture = null
@export var neutral: Texture = null
@export var mad: Texture = null
@export var enraged: Texture = null

func _ready() -> void:
	set_mood(2)

func increase_mood() -> void:
	set_mood(clamp(Global.mood + 1, 0, 4))

func set_mood(value: int) -> void:
	Global.mood = value
	match value:
		0:
			texture = joyous
		1:
			texture = happy
		2:
			texture = neutral
		3:
			texture = mad
		4:
			texture = enraged
