extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 9
	mission_title = "Zuma and the Lighthouse"
	pup_id = "zuma"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Зума, на маяке погас свет! Корабли не видят путь! Помоги!", "duration": 3.5, "voice": "res://assets/audio/voice/m10_intro_ryder.wav"},
		{"speaker": "Зума", "text": "Поплыли! Я включу маяк!", "duration": 3.0, "voice": "res://assets/audio/voice/m10_intro_zuma.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.2, 0.4, 0.55)

func _get_path_color() -> Color:
	return Color(0.85, 0.88, 0.82)

func _get_goal_sprite() -> String:
	return "goal_lighthouse.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Зума", "text": "Ура! Маяк снова светит! Корабли в безопасности!", "duration": 3.0, "voice": "res://assets/audio/voice/m10_celeb_zuma.wav"},
		{"speaker": "Райдер", "text": "Супер, Зума! Ты спас корабли!", "duration": 3.0, "voice": "res://assets/audio/voice/m10_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
