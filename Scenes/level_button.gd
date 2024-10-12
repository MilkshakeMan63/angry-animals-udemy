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
	level_scene = load("res://Scenes/level%s.tscn" % level_number)


func _on_pressed() -> void:
	ScoreManager.set_level_selected(level_number)
	get_tree().change_scene_to_packed(level_scene)


func _on_mouse_entered() -> void:
	scale = HOVER_SCALE


func _on_mouse_exited() -> void:
	scale = DEFAULT_SCALE
