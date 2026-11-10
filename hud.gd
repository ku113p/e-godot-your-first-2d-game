class_name HUD
extends CanvasLayer

signal start_game
signal to_main_menu


func _ready() -> void:
	hide()
	_upd_best()


func _upd_best() -> void:
	$Best.text = "Best: " + String.num_int64(Records.best)


func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over(new_record: bool) -> void:
	var msg := "Game Over"
	if new_record:
		msg += "\nNew record!"
		_upd_best()
	show_message(msg)
	
	await $MessageTimer.timeout
	
	show_start()


func show_start() -> void:
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$Buttons.show()


func hide_start() -> void:
	$Message.hide()
	$Buttons.hide()


func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)


func _on_start_button_pressed() -> void:
	$Buttons.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()


func _on_main_menu_pressed() -> void:
	hide()
	to_main_menu.emit()
