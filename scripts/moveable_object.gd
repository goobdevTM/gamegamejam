class_name MoveableObject

extends Node2D

@export var size : Vector2 = Vector2(20,20) 
@export var collision_offset : Vector2 = Vector2(0,0)
@export var slide : bool = false
@export var has_gravity : bool = false

var velocity : Vector2 = Vector2(0,0)
var y_vel : float = 0

var graviting : bool = false

const max_vel : float = 5

func do_slide() -> void:
	while velocity.length() > 0.08:
		velocity *= 0.9
		position += (velocity.normalized() * clamp(velocity.length(), -max_vel, max_vel)) * Globals.global_delta * 144
		clamp_pos()
		await get_tree().create_timer(0).timeout
		
func do_gravitating() -> void:
	if not graviting:
		graviting = true
		if velocity.y > 0:
			y_vel = velocity.y
			velocity.y = 0
		while has_gravity:
			if position.y > 70:
				position.y = 70
				y_vel = 0
			else:
				y_vel += Globals.global_delta * 9
				position.y += y_vel
			clamp_pos()
			await get_tree().create_timer(0).timeout
		graviting = false
		
func clamp_pos() -> void:
	position.x = clamp(position.x, -160 + (size.x / 2) - collision_offset.x, 160 - (size.x / 2) - collision_offset.x)
	position.y = clamp(position.y, -90 + (size.y / 2) - collision_offset.y, 90 - (size.y / 2) - collision_offset.y)
