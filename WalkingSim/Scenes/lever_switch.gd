extends Area3D

var switch_pulled = false

func switch_interact():
	if not switch_pulled:
		switch_pulled = true
		$"Lever Switch/AnimationPlayer".play ("Po_Bo|Level_Down")
