extends Area2D

const SPAWN_Y = 0
const FINISH_Y = 535
var speed = 0
var hit = false
var bpm = 150
var difficulty = 4

func _ready():
	speed = (FINISH_Y - SPAWN_Y) / (60.0 / bpm * difficulty)
	
func _physics_process(delta):
	if !hit:
		translate(Vector2(0, speed * delta))
	else:
		destroy(null)

func init(position):
	match position:
		0:
			"""Spawn to the left lane"""
			$AnimatedSprite.set_frame(0)
		1:
			"""Spawn to the middle lane"""
			$AnimatedSprite.set_frame(1)
		2:
			"""Spawn to the right lane"""
			$AnimatedSprite.set_frame(2)

func set_hit():
	hit = true

func destroy(status):
#	speed = 0
	$AnimatedSprite.visible = false
	$CPUParticles2D.emitting = true
	$EmittingTimer.start()
	if status != null:
		$AccuracyLabel.set_text(status)

func _on_EmittingTimer_timeout():
	queue_free()
