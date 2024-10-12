extends Node2D

const ANIMAL = preload("res://Scenes/animal.tscn")
const MAIN = preload("res://Scenes/main.tscn")

@onready var animal_start: Marker2D = $AnimalStart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_animal()
	SignalManager.on_animal_died.connect(spawn_animal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_packed(MAIN)


func spawn_animal(): #Spawns the animal at the animal start position marker
	var new_animal = ANIMAL.instantiate() # load animal blueprint into game as an instance. sets that instance to a var to be referenced later.
	new_animal.position = animal_start.position  # set position of new animal to marker position
	add_child(new_animal) # add new animal as child node to current scene
	
