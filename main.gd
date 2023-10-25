extends Node3D

enum State {LOBBY, RUNNING, END}

var state:State
var enemy_ressource = load("res://zombie_enemy.tscn")
var enemy_array = []
var rng = RandomNumberGenerator.new()

@onready var start = $HUD/StartPanel
@onready var timer = $SpawnTimer
@onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.LOBBY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match state :
		State.LOBBY :
			# LOBBY STATE
			if Input.is_action_just_pressed("ui_accept"):
				state = State.RUNNING
				start.visible = false
				timer.start()
		State.RUNNING : 
			# RUNNING STATE
			
			pass
		State.END : 
			pass

func _physics_process(delta):
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)

func spawn_enemy():
	var enemy_instance = enemy_ressource.instantiate()
	add_child(enemy_instance)
	enemy_array.append(enemy_instance)
	enemy_instance.position = get_spawn_location()

func get_spawn_location():
	var rng_offset = rng.randi_range(-20,20)
	var location_rng = rng.randi_range(1, 4)
	match location_rng :
		1:
			#left spawn
			return Vector3(-20,1,rng_offset)
		2:
			#right spawn
			return Vector3(20,1,rng_offset)
		3:
			#top spawn
			return Vector3(rng_offset,1,-20)
		4:
			#bottom spawn
			return Vector3(rng_offset,1,20)

func _on_spawn_timer_timeout():
	spawn_enemy()
