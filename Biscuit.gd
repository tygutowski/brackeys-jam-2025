extends Resource
class_name Biscuit

enum stageEnum {INGREDIENTS, RAW, SHAPED, COOKED}
var stage = stageEnum.INGREDIENTS
var quality: float = 0 # based on cook time
var biscuit_price: float = 10
var time_cooked: float = 0
var cook_amount: int = -1
var bake_time: float = 0

func cook(time: float) -> void:
	time_cooked += time

# sprite indices:
# 2 = undercooked, 3 = perfect, 7 = overcooked, 4 = burnt

func set_quality(bake_time: float) -> void:
	if bake_time <= 0.0:
		cook_amount = -1
		quality = 0.0
		return

	var value: float = clamp(time_cooked / bake_time, 0.0, 1.0)

	# decide sprite first
	if value <= 0.45:
		cook_amount = 2
	elif value <= 0.55:
		cook_amount = 3
	elif value <= 0.80:
		cook_amount = 6
	else:
		cook_amount = 4

	if value <= 0.45:
		quality = value / 0.45
	elif value <= 0.55:
		quality = 1.0
	elif value <= 0.80:
		quality = 1.0 - (value - 0.55) / 0.25
	else:
		quality = 0.0
	print(quality)

func get_price() -> float:
	var stage_modifier: float = 1.0
	match stage:
		stageEnum.RAW:
			return -1
		stageEnum.SHAPED:
			return -1
		stageEnum.COOKED:
			return 1
	return biscuit_price * stage_modifier * quality
