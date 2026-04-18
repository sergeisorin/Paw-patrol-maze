extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 6
	mission_title = "Team Maze to the Lookout"
	pup_id = "chase"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Все щенки собираются на Базе для праздника!", "duration": 3.5, "voice": "res://assets/audio/voice/m7_intro_ryder.wav"},
		{"speaker": "Гонщик", "text": "Гонщик ведёт команду! Вперёд к Базе!", "duration": 3.0, "voice": "res://assets/audio/voice/m7_intro_chase.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.4, 0.45, 0.35)

func _get_path_color() -> Color:
	return Color(0.85, 0.82, 0.72)

func _get_goal_sprite() -> String:
	return "goal_lookout.png"

func _get_tile_style() -> String:
	return "indoor"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Гонщик", "text": "Мы добрались до Базы!", "duration": 3.0, "voice": "res://assets/audio/voice/m7_celeb_chase.wav"},
		{"speaker": "Райдер", "text": "Все щенки в сборе! Ты настоящий герой!", "duration": 3.5, "voice": "res://assets/audio/voice/m7_celeb_ryder1.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
