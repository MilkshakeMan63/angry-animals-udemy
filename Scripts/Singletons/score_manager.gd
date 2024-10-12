extends Node

var _current_level: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_level_selected(ls: int):
	_current_level = ls
	
	
func get_level_selected():
	return _current_level
