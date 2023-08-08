extends CharacterBody3D

var enemy_walking = true

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_node("/root/World/Player")

var movement_speed = 1.5

func _ready():
	call_deferred("get_target")
	$AnimationPlayer.play("Walking")
func get_target():
	nav_agent.target_position = player.global_transform.origin
	movement_speed *= 1.05
	print(movement_speed)

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		get_target()
	
	var current_position = global_position
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = next_position - current_position
	new_velocity = new_velocity.normalized() * movement_speed
	look_at(player.global_transform.origin)
	velocity = new_velocity
	move_and_slide()

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://jumpscare.tscn")
