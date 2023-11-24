extends CharacterBody3D


# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 60
const JUMP_VELOCITY = 15
const SPEED = 15

var target_velocity = Vector3.ZERO

var angle_rotation = 0
var isInversed = false;

enum {UP, BACKWARD, BACKWARD_STRAF, NONE}

# const SPEED = 2
var bullet_ressource = load("res://bullet.tscn")
@onready var damage_invuln = $DamageInvuln
@onready var shot_cooldown = $ShotCooldown

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

signal health_changed(health)
signal foo

var health = 100

var enemy = 0

func _process(delta):
	if enemy > 0:
		damage()

func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

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
	if Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left"):
		if !Input.is_action_pressed("move_forward") && !Input.is_action_pressed("move_backward"):
			if !isInversed :
				direction.x += 1 - abs(angle_rotation)
				direction.z += angle_rotation
			else :
				direction.x -= 1 - abs(angle_rotation)
				direction.z += angle_rotation
			rotate = NONE
		else :
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
	if Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		if !Input.is_action_pressed("move_forward") && !Input.is_action_pressed("move_backward"):
			if !isInversed :
				direction.x -= 1 - abs(angle_rotation)
				direction.z -= angle_rotation
			else :
				direction.x += 1 - abs(angle_rotation)
				direction.z -= angle_rotation
			rotate = NONE
		else :
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
	if(Input.is_action_pressed("shoot_up")or Input.is_action_pressed("shoot_down") or Input.is_action_pressed("shoot_left") or Input.is_action_pressed("shoot_right")):
		var shoot_dir = Input.get_vector("shoot_up", "shoot_down" ,"shoot_left", "shoot_right")
		var shot = (transform.basis * Vector3(shoot_dir.x, 0, shoot_dir.y)).normalized()
		if(shot_cooldown.is_stopped()):
			shoot(shot)

func shoot(shot):
	var level_root = get_tree().get_root()
	var player_position = transform.origin.normalized()
	var bullet_instance = bullet_ressource.instantiate()
	var bullet_position = Vector3(player_position.x, 1, player_position.z)
	##level_root.add_child(bullet_instance)
	bullet_instance.position = bullet_position
	bullet_instance.global_transform = global_transform
	bullet_instance.global_transform.origin = Vector3(global_transform.origin.x, 0.5, global_transform.origin.z)
	level_root.get_node("Main").add_child(bullet_instance)
	bullet_instance.apply_central_force(shot*10)
	print("pew", bullet_instance)
	shot_cooldown.start()

func damage():
	if damage_invuln.is_stopped():
		print("ow")
		health = health - 10
		damage_invuln.start()
		print("emitting")
		health_changed.emit(health)


func _on_area_3d_body_entered(body):
	enemy+=1

func _on_area_3d_body_exited(body):
	enemy-=1
