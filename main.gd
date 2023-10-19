extends Node3D
enum State {LOBBY, RUNNING, END}
var state:State
# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.LOBBY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(state) :
		State.LOBBY : {
			# LOBBY STATE
			
		}
		State.RUNNING : {
			# RUNNING STATE
		}
		State.END : {
			# END STATE
		}
