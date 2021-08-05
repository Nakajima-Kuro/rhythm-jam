extends Node2D

export (PackedScene) var note
var score = 0
var perfect = 0
var good = 0
var okay = 0
var max_combo = 0

var combo = 0

"""Number of notes will be spawn on beat 1, 2, 3, 4 of the measure"""
var spawn_beat = [0, 0, 0, 0]

func _ready():
	randomize()
	$Conductor.play_with_beat_offset(2)
#	$Conductor.play_from_beat(620, 2)

"""Triggered every beat"""
func _on_Conductor_beat(position):
	if position > 5:
		spawn_beat = [1, 1, 1, 0]
	if position > 16:
		spawn_beat = [1, 1, 1, 1]
	if position > 40:
		spawn_beat = [2, 2, 2, 0]
	if position > 76:
		spawn_beat = [1, 0, 0, 1]
	if position > 106:
		spawn_beat = [2, 2, 2, 1]
	if position > 200:
		spawn_beat = [1, 1, 1, 0]
	if position > 306:
		spawn_beat = [2, 2, 2, 0]
	if position > 442:
		spawn_beat = [0, 1, 1, 1]
	if position > 474:
		spawn_beat = [0, 2, 2, 1]
	if position > 556:
		spawn_beat = [1, 1, 1, 1]
	if position > 600:
		spawn_beat = [0, 0, 0, 0]
	if position > 626:
		spawn_beat = [2, 0, 0, 0]
	if position > 627:
		spawn_beat = [0, 0, 0, 0]
	if position > 640:
		$Conductor.stop()
		var values = {"score" : score, "perfect" : perfect, 
		"good" : good, "okay" : okay, "max_combo" : max_combo}
		Global.values = values
		get_tree().change_scene("res://scenes/game_over/GameOver.tscn")
		
"""Trigger every beat, in loop of 4"""
func _on_Conductor_measure(position):
	_spawn_notes(spawn_beat[position - 1])

"""Spawn note base on number of note"""
func _spawn_notes(note_no):
	var spawned_position = []
	var spawn_position = randi() % 3
	for i in note_no:
		"""Make sure no note being spawn twice in one lane"""
		while spawned_position.has(spawn_position):
			spawn_position = randi() % 3
		spawned_position.append(spawn_position)
		"""Init the note instance and add to scene"""
		var instance = note.instance()
		instance.init(spawn_position)
		instance.position = $SpawnPosition.get_spawn_position(spawn_position)
		add_child(instance)
		
"""handle miss note that go out of the screen"""
func _on_Area2D_area_entered(area):
	if area.is_in_group("note"):
		area.destroy(null)

"""Handle the score and combo system"""
func increase_score(num):
	score += num
	$VBoxContainer/ScoreLabel.set_text(String(score))
	"""Handle combo"""
	if num == 0:
		if combo > max_combo:
			max_combo = combo
		combo = 0
		$VBoxContainer/ComboLabel.set_text("")
	else:
		combo += 1
		$VBoxContainer/ComboLabel.set_text("Combo" + String(combo))
