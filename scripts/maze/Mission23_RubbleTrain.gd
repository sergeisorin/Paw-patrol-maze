extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 22
	mission_title = "Rubble and the Train"
	pup_id = "rubble"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Крепыш, игрушечный поезд сошёл с рельсов! Помоги!", "duration": 3.5, "voice": "res://assets/audio/voice/m23_intro_ryder.wav"},
		{"speaker": "Крепыш", "text": "Крепыш готов! Поставлю поезд на рельсы!", "duration": 3.0, "voice": "res://assets/audio/voice/m23_intro_rubble.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.55, 0.45, 0.2)

func _get_path_color() -> Color:
	return Color(0.9, 0.85, 0.72)

func _get_goal_sprite() -> String:
	return "goal_train.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Крепыш", "text": "Ура! Поезд снова едет! Ту-ту!", "duration": 3.0, "voice": "res://assets/audio/voice/m23_celeb_rubble.wav"},
		{"speaker": "Райдер", "text": "Отлично, Крепыш! Поезд снова в пути!", "duration": 3.0, "voice": "res://assets/audio/voice/m23_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
