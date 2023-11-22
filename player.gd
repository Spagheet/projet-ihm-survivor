extends CharacterBody3D



# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 60
const JUMP_VELOCITY = 15

var target_velocity = Vector3.ZERO

var angle_rotation = 0
var isInversed = false;

enum {UP, BACKWARD, BACKWARD_STRAF}

# const SPEED = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	var rotate = UP

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_backward"):
		if !isInversed :
			direction.z += 1 - abs(angle_rotation)
		else :
			direction.z -= 1 - abs(angle_rotation)
		direction.x -= angle_rotation
		rotate = BACKWARD
	if Input.is_action_pressed("move_forward"):
		if !isInversed :
			direction.z -= 1 - abs(angle_rotation)
		else :
			direction.z += 1 - abs(angle_rotation)
		direction.x += angle_rotation
	if Input.is_action_pressed("move_right"):
		if angle_rotation >= 1:
			angle_rotation = 1
			isInversed = true

		if !isInversed :
			angle_rotation += 0.025
		else : 
			angle_rotation -= 0.025
			if angle_rotation <= -1 :
				isInversed = false
				angle_rotation = -1
		
		if rotate == BACKWARD : 
			rotate = BACKWARD_STRAF
	if Input.is_action_pressed("move_left"):
		if angle_rotation <= -1:
			angle_rotation = -1
			isInversed = true
			
		if !isInversed :
			angle_rotation -= 0.025
		else : 
			angle_rotation += 0.025
			if angle_rotation >= 1 :
				isInversed = false
				angle_rotation = 1
		if rotate == BACKWARD : 
			rotate = BACKWARD_STRAF
	
		# Handle Jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		target_velocity.y = JUMP_VELOCITY
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		if rotate == UP : 
			$Pivot.look_at(position + direction, Vector3.UP)
		if rotate == BACKWARD_STRAF :
			var inv_rotate = direction
			inv_rotate.z = - inv_rotate.z
			inv_rotate.x = - inv_rotate.x
			$Pivot.look_at(position + inv_rotate, Vector3.UP)
	
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()

