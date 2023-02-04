extends Spatial

export var time_between_noise = 0.5
export var min_pitch = 0.8
export var max_pitch = 1.2
export var sounds: Array

var audio_stream_right: AudioStreamPlayer3D
var audio_stream_left: AudioStreamPlayer3D


var played_right = false
var elapsed_time = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	audio_stream_right = get_node("AudioFoot") 
	audio_stream_left = get_node("AudioFoot2")
	
func play_sound(delta) :
	elapsed_time += delta
	if (elapsed_time > time_between_noise) : 
		elapsed_time = 0.0
		var sound_id = rng.randf_range(0.0, len(sounds))
		var pitch = rng.randf_range(min_pitch, max_pitch)
		if (played_right) : 
			audio_stream_left.stream = sounds[sound_id]
			audio_stream_left.pitch_scale = pitch
			audio_stream_left.play()
			played_right = false
		else : 
			audio_stream_right.stream = sounds[sound_id]
			audio_stream_right.pitch_scale = pitch
			played_right = true
			audio_stream_right.play()


