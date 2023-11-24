extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@export var SPEED = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity.y = 0
	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	target_location.y = 0;
	nav_agent.target_position = target_location
