class_name TrainingWeights
extends BaseItemStrat

@export var mult:float = 1.5

func bullet_boost(bullet):
	bullet.damage *= mult * int(ComboCount.comboCount/10)
