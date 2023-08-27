extends Node3D

func _on_area_3d_area_entered():
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
