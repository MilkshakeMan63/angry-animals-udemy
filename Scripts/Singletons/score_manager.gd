extends Node

const DEFAULT_SCORE: int = 1000
const SCORES_PATH = "user://aniamls.json"


var _current_level: int = 1
var _level_scores: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_from_disc()


func set_level_selected(ls: int):
	_current_level = ls
	
	
func get_level_selected():
	return _current_level


func check_and_add(level: String):
	if _level_scores.has(level) == false: # if the dictionay does not have the level saved in it then set it to the default score
		_level_scores[level] = DEFAULT_SCORE


func set_score_for_level(score: int, level: String):
	check_and_add(level)
	if _level_scores[level] > score: # if the level scores saved value in the dictionary is higher the the score set the score to the level score
		_level_scores[level] = score
		save_to_disc()

func get_best_for_level(level: String):
	check_and_add(level)
	return _level_scores[level]


func save_to_disc():
	var file = FileAccess.open(SCORES_PATH, FileAccess.WRITE) # get the file path and set the var to the file path and overwrite anything in that file
	var score_json_str = JSON.stringify(_level_scores) # create a json formate of the dictionary to save it
	file.store_string(score_json_str) # save the json string to the file


func load_from_disc():
	var file = FileAccess.open(SCORES_PATH, FileAccess.READ) # access the file and save as var
	if file == null: # if there is no file create one
		save_to_disc()
	else:
		var data = file.get_as_text() # get the file data as a text 
		_level_scores = JSON.parse_string(data) # this will convert the json file data into string for gdscript
