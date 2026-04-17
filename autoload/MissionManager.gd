extends Node

signal mission_started(mission_index)
signal mission_transition_started
signal mission_transition_finished

enum Phase { INTRO, PLAYING, CELEBRATION, TRANSITION }

var current_phase: int = Phase.INTRO

func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS

func load_mission(mission_index: int) -> void:
	var data = GameManager.get_mission(mission_index)
	if data.empty():
		push_error("Invalid mission index: " + str(mission_index))
		return

	emit_signal("mission_transition_started")
	current_phase = Phase.TRANSITION

	yield(get_tree().create_timer(0.5), "timeout")

	var err = get_tree().change_scene(data.scene)
	if err != OK:
		push_error("Failed to load mission scene: " + data.scene)
		return

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	current_phase = Phase.INTRO
	emit_signal("mission_started", mission_index)
	emit_signal("mission_transition_finished")

func start_playing() -> void:
	current_phase = Phase.PLAYING

func start_celebration() -> void:
	current_phase = Phase.CELEBRATION

func finish_mission() -> void:
	GameManager.advance_to_next_mission()

func go_to_main_menu() -> void:
	current_phase = Phase.INTRO
	get_tree().change_scene("res://scenes/ui/MainMenu.tscn")
