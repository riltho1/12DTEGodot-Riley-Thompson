extends CharacterBody3D

var enemy_walking = true

@onready var nav_agent = $NavigationAgent3D
@onready var player = get_node("/root/World/Player")

@onready var flee_point = get_node("/root/World/Flee Point")

enum state{SEARCHING,FLEEING,WAITING}

var target
var enemy_state = state.WAITING

var movement_speed = 1.5

func set_state(s):
	if $Timer.is_stopped():
		enemy_state = s
		if enemy_state == state.SEARCHING:
			print("set to flee")
			get_target(player)
		if enemy_state == state.FLEEING:
			print("set to flee")
			get_target(flee_point)

func _ready():
	call_deferred("get_target")
	$AnimationPlayer.play("Walking")

func get_target(target):
	nav_agent.target_position = target.global_transform.origin
	movement_speed *= 1.05
	print(movement_speed)

func _physics_process(delta):
	if enemy_state == state.WAITING:
		return
	if nav_agent.is_navigation_finished():
		set_state(enemy_state)
	
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


func _on_timer_timeout():
	print("resuming hunt")
	set_state(state.SEARCHING)


func _on_flee_area_body_entered(body):
	if body == self:
		print("waiting")
		set_state(state.WAITING)
		$Timer.start()
