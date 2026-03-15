extends Node

var global_delta : float

func _process(delta: float) -> void:
	global_delta = delta

var current_scene: int = 0
var scene_data: Array[Dictionary] = [
	{"scene": "res://scenes/Scene Scenes/scene_0_front_porch.tscn", "song": "uid://chpihhudnu3k7"}
	]
