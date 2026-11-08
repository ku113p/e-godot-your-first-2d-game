extends Node

const PATH := "user://records.json"
const BEST_KEY := "best"

var best: int = 0

func _ready() -> void:
	_load()

func submit(new: int) -> bool:
	if best >= new:
		return false
	best = new
	_save()
	return true

func _save() -> void:
	var data := { BEST_KEY: best }
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	if file == null:
		push_error("Save failed: %s", FileAccess.get_open_error())
	else:
		file.store_string(JSON.stringify(data))

func _load() -> void:
	var file := FileAccess.open(PATH, FileAccess.READ)
	if file == null:
		push_error("Load failed: %s", FileAccess.get_open_error())
		return
	
	var text := FileAccess.get_file_as_string(PATH)
	var data: Dictionary = JSON.parse_string(text)
	if not data is Dictionary:
		push_warning("Records save broken. starts new one")
	else:
		best = int(data.get(BEST_KEY, 0))
