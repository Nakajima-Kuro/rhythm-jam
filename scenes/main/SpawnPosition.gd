extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_spawn_position(position):
	match position:
		0:
			return $Left.position
		1:
			return $Up.position
		2:
			return $Right.position
	return null
