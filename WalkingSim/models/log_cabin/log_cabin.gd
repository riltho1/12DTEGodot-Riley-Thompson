extends Node3D

signal door_animation
var door_open = false
func _process(delta):
	if Input.is_action_just_pressed("use"):
		emit_signal("door_animation")


func interact_door():
	if not door_open:
		door_open = true
		$AnimationPlayer.play("Door_Open")
