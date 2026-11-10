class_name MainMenu
extends CanvasLayer

signal play_pressed

@onready var best_label: Label = $All/Best


func _ready() -> void:
	upd_best()


func upd_best() -> void:
	best_label.text = "Best: " + String.num_int64(Records.best)


func _on_play_pressed() -> void:
	hide()
	play_pressed.emit()


func _on_exit_pressed() -> void:
	get_tree().quit()
