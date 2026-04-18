extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 3
	mission_title = "Zuma and the Dock Maze"
	pup_id = "zuma"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Игрушечный кораблик уплыл к дальнему причалу!", "duration": 3.5, "voice": "res://assets/audio/voice/m4_intro_ryder.wav"},
		{"speaker": "Зума", "text": "Ныряем! Найдём кораблик!", "duration": 2.5, "voice": "res://assets/audio/voice/m4_intro_zuma.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.3, 0.5, 0.6)

func _get_path_color() -> Color:
	return Color(0.92, 0.88, 0.72)

func _get_goal_sprite() -> String:
	return "goal_boat.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Зума", "text": "Кораблик найден! Плыви домой!", "duration": 3.0, "voice": "res://assets/audio/voice/m4_celeb_zuma.wav"},
		{"speaker": "Райдер", "text": "Ты заработал Звезду Моря!", "duration": 3.0, "voice": "res://assets/audio/voice/m4_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
