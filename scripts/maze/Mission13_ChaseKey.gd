extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 12
	mission_title = "Chase and the Missing Key"
	pup_id = "chase"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Гонщик, в городе потеряли ключ от ворот! Помоги найти!", "duration": 3.5, "voice": "res://assets/audio/voice/m13_intro_ryder.wav"},
		{"speaker": "Гонщик", "text": "Гонщик берёт след! Найду ключ!", "duration": 3.0, "voice": "res://assets/audio/voice/m13_intro_chase.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.3, 0.35, 0.55)

func _get_path_color() -> Color:
	return Color(0.82, 0.82, 0.78)

func _get_goal_sprite() -> String:
	return "goal_key.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Гонщик", "text": "Ура! Ключ найден! Ворота открыты!", "duration": 3.0, "voice": "res://assets/audio/voice/m13_celeb_chase.wav"},
		{"speaker": "Райдер", "text": "Супер работа, Гонщик! Ты лучший следопыт!", "duration": 3.0, "voice": "res://assets/audio/voice/m13_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
