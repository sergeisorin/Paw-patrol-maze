extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 20
	mission_title = "Skye and the Rainbow"
	pup_id = "skye"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Скай, после дождя появилась радуга! Полети и посмотри!", "duration": 3.5, "voice": "res://assets/audio/voice/m21_intro_ryder.wav"},
		{"speaker": "Скай", "text": "Радуга! Я хочу полететь к ней!", "duration": 3.0, "voice": "res://assets/audio/voice/m21_intro_skye.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.5, 0.3, 0.5)

func _get_path_color() -> Color:
	return Color(0.88, 0.85, 0.82)

func _get_goal_sprite() -> String:
	return "goal_rainbow.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Скай", "text": "Ура! Я долетела до радуги! Какая красота!", "duration": 3.0, "voice": "res://assets/audio/voice/m21_celeb_skye.wav"},
		{"speaker": "Райдер", "text": "Чудесно, Скай! Ты коснулась радуги!", "duration": 3.0, "voice": "res://assets/audio/voice/m21_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
