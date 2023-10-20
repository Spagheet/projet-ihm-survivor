extends Node3D
enum State {LOBBY, RUNNING, END}
@onready var state:State
@onready var start = $HUD/StartPanel
# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.LOBBY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var enemy_array = []
	match state :
		State.LOBBY :
			# LOBBY STATE
			if Input.is_action_just_pressed("ui_accept"):
				state = State.RUNNING
				start.visible = false
		State.RUNNING : 
			# RUNNING STATE
			pass
		State.END : 
			start.visible = true
			pass
