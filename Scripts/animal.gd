extends RigidBody2D

enum ANIMAL_STATE {READY, DRAG, RELEASE} # three states the animal can be in

var _state: ANIMAL_STATE = ANIMAL_STATE.READY # when the scene is first loaded it is in the ready state

@onready var label: Label = $Label


func _ready() -> void:
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	update(delta) 
	label.text = "%s" %ANIMAL_STATE.keys()[_state]


func update(delta: float): # update to one of the 3 states
	match _state: # if the _state matches DRAG then run update_drag()
		ANIMAL_STATE.DRAG: # when the animal is in drag state we can run the update drag function
			update_drag()


func set_new_state(new_state: ANIMAL_STATE):
	_state = new_state
	if _state == ANIMAL_STATE.RELEASE:
		freeze = false
	elif _state == ANIMAL_STATE.DRAG:
		pass
		
		
func update_drag():
	if detect_release() == true: # if this function is true just return from this function so we don't drag anything
		return 
	
	var gmp = get_global_mouse_position() # set gmp to global mouse position
	position = gmp # set the position of the animal to the gmp position


func detect_release() -> bool:
	if _state == ANIMAL_STATE.DRAG: # if the state of the animal was DRAG continue
		if Input.is_action_just_released("drag") == true: # and if the input was just released 
			set_new_state(ANIMAL_STATE.RELEASE) # afer we lift off the mouse button set the animal state to release
			return true
	return false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	print("Off screen and deleted")
	SignalManager.on_animal_died.emit()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if _state == ANIMAL_STATE.READY and event.is_action_pressed("drag"): # when we click on the animal and it state is ready, which it is on spawn.
		set_new_state(ANIMAL_STATE.DRAG) # we can set its state to DRAG which is used up in the code to drag the animal.
