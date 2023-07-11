extends Node3D
"""
var door_state = false

@onready var ray = $Camera3D/RayCast3D

func _input(event):
	
	if Input.is_action_just_pressed("use"):
		ray.get_collider().queue_free()
		$AnimationPlayer.play("Door_Open")
"""
