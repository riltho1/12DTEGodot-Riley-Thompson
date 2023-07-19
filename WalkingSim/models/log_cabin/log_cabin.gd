extends Node3D

var door_open = false

func interact_door():
	if not door_open:
		door_open = true
		$AnimationPlayer.play("Door_Open")
	else:
		door_open = false
		$AnimationPlayer.play("Door_Close")
		
