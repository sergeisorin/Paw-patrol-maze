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

func _get_maze_size() -> Vector2:
	return Vector2(15, 11)

func _get_wall_color() -> Color:
	return Color(0.4, 0.45, 0.35)

func _get_path_color() -> Color:
	return Color(0.85, 0.82, 0.72)

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
		[W,P,P,P,C,P,W,P,P,C,P,P,P,G,W],
		[W,P,W,W,W,P,W,P,W,W,W,W,W,P,W],
		[W,P,W,D,P,P,P,P,P,P,W,P,P,P,W],
		[W,P,W,P,W,W,W,W,W,P,W,P,W,W,W],
		[W,C,P,P,P,P,P,C,W,P,P,P,P,D,W],
		[W,W,W,W,W,P,W,P,W,W,W,W,W,P,W],
		[W,P,P,P,W,P,W,P,P,C,W,P,P,P,W],
		[W,P,W,P,W,C,W,W,W,P,W,P,W,W,W],
		[W,S,P,P,P,P,P,D,P,P,P,P,C,P,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Гонщик", "text": "Мы добрались до Базы!", "duration": 3.0, "voice": "res://assets/audio/voice/m7_celeb_chase.wav"},
		{"speaker": "Райдер", "text": "Все щенки в сборе! Ты настоящий герой!", "duration": 3.5, "voice": "res://assets/audio/voice/m7_celeb_ryder1.wav"},
		{"speaker": "Райдер", "text": "Спасибо за помощь! Щенячий Патруль — вперёд!", "duration": 4.0, "voice": "res://assets/audio/voice/m7_celeb_ryder2.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(2.0), "timeout")
	GameManager.complete_mission(mission_index)
	MissionManager.go_to_main_menu()
