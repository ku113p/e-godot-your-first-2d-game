extends Node

@export var mob_scene: PackedScene

@onready var score_timer: Timer = $World/ScoreTimer
@onready var mob_timer: Timer = $World/MobTimer
@onready var start_timer: Timer = $World/StartTimer
@onready var player: Area2D = $World/Player
@onready var start_position: Marker2D = $World/StartPosition
@onready var mob_spawn_location: PathFollow2D = $World/MobPath/MobSpawnLocation
@onready var pause_menu: PauseMenu = $PauseMenu

var score: int
var playing: bool = false


func game_over() -> void:
	playing = false
	
	score_timer.stop()
	mob_timer.stop()
	
	var new_record := Records.submit(score)
	
	$HUD.show_game_over(new_record)
	
	$Music.stop()
	$DeathSound.play()


func new_game() -> void:	
	score = 0
	playing = true
	
	player.start(start_position.position)
	start_timer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	$Music.play()
	$World.get_tree().call_group("mobs", "queue_free")


func _on_mob_timer_timeout() -> void:
	var mob: RigidBody2D = mob_scene.instantiate()
	
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	var direction: float = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity: Vector2 = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	$World.add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	mob_timer.start()
	score_timer.start()


func _unhandled_input(event: InputEvent) -> void:
	if playing and event.is_action_pressed("pause"):
		_set_paused(not get_tree().paused)


func _set_paused(value: bool) -> void:
	get_tree().paused = value
	pause_menu.visible = value


func _on_pause_menu_restart_pressed() -> void:
	_set_paused(false)
	get_tree().reload_current_scene()


func _on_pause_menu_resume_pressed() -> void:
	_set_paused(false)
