"""Code tutorial by LegionGames. Thank you for helping me with this rymthm process logic"""
extends AudioStreamPlayer

export var bpm := 150
export var measures := 4

"""Tracking the position of the song"""
var song_position = 0.0
var song_position_in_beat = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

"""Determineing how close to the beat an event is"""
var closet = 0
var time_off_beat = 0.0

signal beat(position)
signal measure(position)

func _ready():
	sec_per_beat = 60.0 / bpm

func _physics_process(delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beat = int(floor(song_position / sec_per_beat)) + beats_before_start
		_report_beat()

"""Keep track of the beat in the song and emit signal to others"""
func _report_beat():
	if last_reported_beat < song_position_in_beat:
		if measure > measures:
			measure = 1
		emit_signal("beat", song_position_in_beat)
		emit_signal("measure", measure)
		last_reported_beat = song_position_in_beat
		measure += 1
		
func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()
	
func closet_beat(nth):
	closet = int(round((song_position / sec_per_beat) / nth ) * nth)
	time_off_beat = abs(closet * sec_per_beat - song_position)
	return Vector2(closet, time_off_beat)
	
"""For easy test to play at middle of the song"""
func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures

func _on_StartTimer_timeout():
	song_position_in_beat += 1
	if song_position_in_beat < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beat == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		measure = 1
		$StartTimer.stop()
	_report_beat()
