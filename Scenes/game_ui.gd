extends Control

const MAIN = preload("res://Scenes/main.tscn")

@onready var press_space_label: Label = $MarginContainer/VBoxContainer2/PressSpaceLabel
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var attemtps_label: Label = $MarginContainer/VBoxContainer/AttemtpsLabel
@onready var game_sound: AudioStreamPlayer = $GameSound
@onready var v_box_container_2: VBoxContainer = $MarginContainer/VBoxContainer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_label.text = "LEVEL %s" % ScoreManager.get_level_selected()
	update_attempts(0)
	SignalManager.on_score_updated.connect(update_attempts)
	SignalManager.on_level_complete.connect(on_level_complete)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space") and v_box_container_2.is_visible_in_tree() or Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_packed(MAIN)


func update_attempts(attempts: int):
	attemtps_label.text = "Attemps %s" % attempts


func on_level_complete():
	v_box_container_2.show()
	game_sound.play()
