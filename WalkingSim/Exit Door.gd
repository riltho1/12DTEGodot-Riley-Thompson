extends Node3D

var exit_avaliable = false

func exit_door():
	if exit_avaliable == false:
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
