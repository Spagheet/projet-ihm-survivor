extends RigidBody3D
signal enemy_dead

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(position : Vector3, direction : Vector3):
	position = position
	direction = direction


func _on_body_entered(body):
	print(body)
	body.queue_free()
