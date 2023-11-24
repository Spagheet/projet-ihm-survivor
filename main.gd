extends Node3D

enum State {LOBBY, RUNNING, END}

var state:State
var enemy_ressource = load("res://zombie_enemy.tscn")
var enemy_array = []
var rng = RandomNumberGenerator.new()

@onready var start = $HUD/StartPanel
@onready var end = $HUD/EndPanel
@onready var health_display = $HUD/HealthPanel/Health
@onready var score_display = $HUD/EndPanel/Score
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
	var target = player.global_transform.origin
	target.y = 0.0
	get_tree().call_group("enemies", "update_target_location", target)

func spawn_enemy():
	var enemy_instance = enemy_ressource.instantiate()
	add_child(enemy_instance)
	enemy_array.append(enemy_instance)
	enemy_instance.position = get_spawn_location()

func get_spawn_location():
	var rng_offset = rng.randi_range(-20,20)
	var location_rng = rng.randi_range(1, 4)
	var height = -0.4
	match location_rng :
		1:
			#left spawn
			return Vector3(-20,height,rng_offset)
		2:
			#right spawn
			return Vector3(20,height,rng_offset)
		3:
			#top spawn
			return Vector3(rng_offset,height,-20)
		4:
			#bottom spawn
			return Vector3(rng_offset,height,20)

func end_game():
	timer.stop()
	state = State.END
	end.visible = true
	score_display.text = str(0)
	player.visible = false


func _on_spawn_timer_timeout():
	spawn_enemy()

func _on_player_health_changed(health) -> void:
	health_display.text = str(health)
	if health <= 0:
		end_game()
