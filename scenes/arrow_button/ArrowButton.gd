extends AnimatedSprite

export var input = ""
var current_note = null

var status = ""

func _unhandled_input(event):
	if input != "" and event.is_action(input):
		if event.is_action_pressed(input, false):
			self.set_frame(1)
			if current_note != null:
				match status:
					"perfect":
						get_parent().increase_score(3)
						get_parent().perfect += 1
					"good":
						get_parent().increase_score(2)
						get_parent().good += 1
					"okay":
						get_parent().increase_score(1)
						get_parent().okay += 1
				current_note.destroy(status)
			else:
				get_parent().increase_score(0)
		else: 
			self.set_frame(0)


func _on_PerfectArea_area_entered(area):
	status = "perfect"

func _on_GoodArea_area_entered(area):
	status = "good"

func _on_OkayArea_area_entered(area):
	if area.is_in_group("note"):
		status = "okay"
		current_note = area	

func _on_PerfectArea_area_exited(area):
	status = "good"

func _on_GoodArea_area_exited(area):
	status = "okay"

func _on_OkayArea_area_exited(area):
	status = ""
	current_note = null
