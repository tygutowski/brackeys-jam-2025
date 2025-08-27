extends Resource
class_name Biscuit

enum stageEnum {RAW, SHAPED, COOKED}
var stage = stageEnum.RAW
var quality: float = 0 # based on cook time
var biscuit_price: float = 10

func set_quality(time: float, duration: float) -> float:
	if duration <= 0.0:
		return 0.0
	var value = clamp(time / duration, 0.0, 1.0)
	if value <= 0.45:
		return value / 0.45
	elif value <= 0.50:
		return 1.0 + (value - 0.45) / 0.05
	elif value <= 0.55:
		return 2.0 - (value - 0.50) / 0.05
	else:
		return 1.0 - (value - 0.55) / 0.45

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
