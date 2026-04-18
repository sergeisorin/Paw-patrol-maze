extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 23
	mission_title = "Rocky and the Telescope"
	pup_id = "rocky"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Рокки, телескоп сломался! А сегодня звездопад!", "duration": 3.5, "voice": "res://assets/audio/voice/m24_intro_ryder.wav"},
		{"speaker": "Рокки", "text": "Не выбрасывай! Я починю телескоп!", "duration": 3.0, "voice": "res://assets/audio/voice/m24_intro_rocky.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.2, 0.3, 0.45)

func _get_path_color() -> Color:
	return Color(0.78, 0.82, 0.88)

func _get_goal_sprite() -> String:
	return "goal_telescope.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Рокки", "text": "Ура! Телескоп работает! Посмотри на звёзды!", "duration": 3.0, "voice": "res://assets/audio/voice/m24_celeb_rocky.wav"},
		{"speaker": "Райдер", "text": "Великолепно, Рокки! Теперь мы видим звёзды!", "duration": 3.0, "voice": "res://assets/audio/voice/m24_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
