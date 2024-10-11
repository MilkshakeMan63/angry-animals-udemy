extends RigidBody2D

enum ANIMAL_STATE {READY, DRAG, RELEASE} # three states the animal can be in

const DRAG_LIM_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0)
const IMPULSE_MULTIPLIER: float = 20.0
const IMPULSE_MAX: float = 1200.0

var _state: ANIMAL_STATE = ANIMAL_STATE.READY # when the scene is first loaded it is in the ready state
var _Start: Vector2 = Vector2.ZERO # setting all these at the start to (0,0)
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_vector: Vector2 = Vector2.ZERO
var _arrow_scale_x: float = 0.0
var _last_collision_count: int = 0

@onready var label: Label = $Label
@onready var stretch: AudioStreamPlayer2D = $Stretch
@onready var arrow: Sprite2D = $Arrow
@onready var launch: AudioStreamPlayer2D = $Launch
@onready var kick: AudioStreamPlayer2D = $Kick


func _ready() -> void:
	arrow.hide()
	_Start = position # set the start position to the current position on ready.
	_arrow_scale_x = arrow.scale.x


func _physics_process(delta: float) -> void:
	update(delta) 
	label.text = "%s\n" %ANIMAL_STATE.keys()[_state]
	label.text += "%.1f,%.1f" % [_dragged_vector.x, _dragged_vector.y]


func update(delta: float): # update to one of the 3 states
	match _state: # if the _state matches DRAG then run update_drag()
		ANIMAL_STATE.DRAG: # when the animal is in drag state we can run the update drag function
			update_drag()
		ANIMAL_STATE.RELEASE:
			update_flight()


func get_impulse():
	return _dragged_vector * -1 * IMPULSE_MULTIPLIER # return the dragged vector value and switch it to a positive and times it by the multiplier


func set_drag():
	_drag_start = get_global_mouse_position() 
	arrow.show()


func set_release():
	freeze = false
	apply_central_impulse(get_impulse()) # apply the impulse from are get_impulse function
	launch.play() # play the launch sound
	arrow.hide()
	SignalManager.on_attempt_made.emit()


func set_new_state(new_state: ANIMAL_STATE):
	_state = new_state
	if _state == ANIMAL_STATE.RELEASE: # if the animal is in state release then set freeze property to false and hide the arrow
		set_release()
	elif _state == ANIMAL_STATE.DRAG: # if the animal is in state drag then set drag start to mouse position and show arrow
		set_drag()


func scale_arrow():
	var impulse_length = get_impulse().length() # get the length of the impulse
	var percentage = impulse_length / IMPULSE_MAX
	arrow.scale.x = (_arrow_scale_x * percentage) + _arrow_scale_x # set the arrow scale in the X. add on the arrow scale so if the percentage is 0 it still shows the arrow.
	arrow.rotation = (_Start - position).angle() # getting the start position and minus the current position and return the vector angle of that  


func play_stretched_sound():
	if(_last_dragged_vector - _dragged_vector).length() > 0:  
		if stretch.playing == false:
			stretch.play()


func get_dragged_vector(gmp: Vector2): 
	return gmp - _drag_start


func drag_in_limits():
	_last_dragged_vector = _dragged_vector
	_dragged_vector.x = clampf(_dragged_vector.x, DRAG_LIM_MIN.x, DRAG_LIM_MAX.x) # sets the max X vector value to the min and max values create a box that the bird can be dragged in
	_dragged_vector.y = clampf(_dragged_vector.y, DRAG_LIM_MIN.y, DRAG_LIM_MAX.y)
	position = _Start + _dragged_vector # set position to start position + the dragged vector value


func update_drag():
	if detect_release() == true: # if this function is true just return from this function so we don't drag anything
		return 
	var gmp = get_global_mouse_position() # set gmp to global mouse position
	_dragged_vector = get_dragged_vector(gmp) # set dragged vector var to get_dragged_vector function. Put gmp into the function so above it returns gmp - _drag_start
	play_stretched_sound() # need to play sound before running drag_in_limits
	drag_in_limits()
	scale_arrow()


func play_collision():
	if _last_collision_count == 0 and get_contact_count() > 0 and kick.playing == false:
		kick.play()
	_last_collision_count = get_contact_count() # get contact is continously checking if it is in contact so as soon as it bounces and is not contacting in goes back to 0


func update_flight():
	play_collision()


func detect_release() -> bool:
	if _state == ANIMAL_STATE.DRAG: # if the state of the animal was DRAG continue
		if Input.is_action_just_released("drag") == true: # and if the input was just released 
			set_new_state(ANIMAL_STATE.RELEASE) # afer we lift off the mouse button set the animal state to release
			return true
	return false


func die():
	SignalManager.on_animal_died.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("Off screen and deleted")
	die()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if _state == ANIMAL_STATE.READY and event.is_action_pressed("drag"): # when we click on the animal and it state is ready, which it is on spawn.
		set_new_state(ANIMAL_STATE.DRAG) # we can set its state to DRAG which is used up in the code to drag the animal.


func _on_sleeping_state_changed() -> void:
	if sleeping == true:
		var cb = get_colliding_bodies() # since this function only runs when the animal stops moving it can only ever be a cup. this gets the colliding body
		if cb.size() > 0: # if the number of colliding bodies is greater than 0 continue down the code
			cb[0].die() # return the first item in the list since it's only ever one item and run the die method it its script
		call_deferred("die")
