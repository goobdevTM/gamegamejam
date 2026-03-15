extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	
	audio_stream_player.bus = &"Music"
	
	audio_stream_player.stream = load(Globals.scene_data[Globals.current_scene]["song"])
	audio_stream_player.play()
