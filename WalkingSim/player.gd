extends CharacterBody3D

@export var mouse_sensitivity = 0.001
var SPEED = 5.0 #modify
@export var run_speed = 10
@export var walk_speed = 5
@export var FRICTION = 0.25
const JUMP_VELOCITY = 4.5

var switches_collected = 0

@onready var ray = $Camera3D/RayCast3D
@onready var interaction_notifier = $Control/InteractionNotifier
@onready var collection_tracker = $Control/MarginContainer/CollectionTracker
@onready var flashlight_power = $Camera3D/SpotLight3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x,-1.2,1.2)
		

func check_ray_hit():
	if ray.is_colliding():
		var collider = ray.get_collider() #This checks the collider to ensure it is not null before being called
		if collider and collider.is_in_group("Pickup"):
			interaction_notifier.visible = true
			if Input.is_action_just_pressed("use"):
				collider.queue_free()
				switches_collected += 1
				collection_tracker.text = "Switches : " + str(switches_collected) + " / 12"
				
		elif collider and collider.is_in_group("Door"):
			interaction_notifier.visible = true
		if Input.is_action_just_pressed("use"):
			collider.queue_free()
			#$AnimationPlayer.play("Door_Open")
	else:
		interaction_notifier.visible = false
		
		
		
func flashlight_enabled():
	if flashlight_power.light_energy > 5:
		flashlight_power.light_energy = 0
	else:
		flashlight_power.light_energy = 6
		

func _physics_process(delta):
	check_ray_hit()
	if Input.is_action_just_pressed("flashlight"):
		flashlight_enabled()
		
	if Input.is_action_pressed("run"):
		SPEED = run_speed
	else:
		SPEED = walk_speed
	#Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, FRICTION)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, FRICTION)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
