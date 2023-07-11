extends Node3D

signal door_animation

func _process(delta):
	if Input.is_action_just_pressed("use"):
		emit_signal("door_animation")
