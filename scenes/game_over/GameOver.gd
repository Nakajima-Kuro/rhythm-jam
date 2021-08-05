extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/ValueContainer/ScoreLabel.set_text(String(Global.values["score"]))
	$HBoxContainer/ValueContainer/PerfectLabel.set_text(String(Global.values["perfect"]))
	$HBoxContainer/ValueContainer/GoodLabel.set_text(String(Global.values["good"]))
	$HBoxContainer/ValueContainer/OkayLabel.set_text(String(Global.values["okay"]))
	$HBoxContainer/ValueContainer/MaxCombo.set_text(String(Global.values["max_combo"]))
