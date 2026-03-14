extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


var objects_hovering : Array[MoveableObject] = []
var main_object : MoveableObject
var offset : Vector2
var global_mouse_pos : Vector2

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	position = get_global_mouse_position() + Vector2(8,8)
	position.x = clamp(position.x, -160+8, 167)
	position.y = clamp(position.y, -90+8, 97)
	if main_object:
		if Input.is_action_just_pressed("click"):
			offset = position - main_object.position
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
		if Input.is_action_just_released("click"):
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
			if main_object.slide:
				main_object.do_slide()
		if Input.is_action_pressed("click"):
			var old_pos : Vector2 = main_object.position
			main_object.position = position - offset
			var clamp_pos : Vector2 = Vector2(\
			clamp(main_object.position.x, -160 + (main_object.size.x / 2) - main_object.collision_offset.x, 160 - (main_object.size.x / 2) - main_object.collision_offset.x),\
			clamp(main_object.position.y, -90 + (main_object.size.y / 2) - main_object.collision_offset.y, 90 - (main_object.size.y / 2) - main_object.collision_offset.y))
			position -= main_object.position - clamp_pos
			main_object.position = position - offset
			main_object.velocity = main_object.position - old_pos
			if not sprite.animation == "finger_drag":
				sprite.play("finger_drag")
		elif not sprite.animation == "finger":
			sprite.play("finger")
	else:
		sprite.play("arrow")
	
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is MoveableObject:
		while Input.is_action_pressed("click"):
			await get_tree().create_timer(0).timeout
		objects_hovering.append(area.get_parent())
		main_object = objects_hovering[len(objects_hovering) - 1]


func _on_area_exited(area: Area2D) -> void:
	await get_tree().create_timer(0).timeout
	if area.get_parent() is MoveableObject:
		while Input.is_action_pressed("click"):
			await get_tree().create_timer(0).timeout
		objects_hovering.erase(area.get_parent())
		if len(objects_hovering) > 0:
			main_object = objects_hovering[len(objects_hovering) - 1]
		else:
			main_object = null
