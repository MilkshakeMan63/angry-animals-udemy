extends TextureButton

const HOVER_SCALE: Vector2 = Vector2(1.1 , 1.1)
const DEFAULT_SCALE: Vector2 = Vector2(1.0 , 1.0)

@export var level_number: int = 1

@onready var level_lable: Label = $MarginContainer/VBoxContainer/LevelLable
@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel

var level_scene: PackedScene 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_lable.text = str(level_number)
	var best_score = ScoreManager.get_best_for_level(str(level_number)) # setting the best score var as the score managers best for level sending in the level number as a string
	score_label.text = str(best_score)
	level_scene = load("res://Scenes/level%s.tscn" % level_number) # loads the saved level scene by using the level number selected for each label when loading


func _on_pressed() -> void:
	ScoreManager.set_level_selected(level_number) # set the score manager current level to the level number export var 
	get_tree().change_scene_to_packed(level_scene)


func _on_mouse_entered() -> void:
	scale = HOVER_SCALE


func _on_mouse_exited() -> void:
	scale = DEFAULT_SCALE
