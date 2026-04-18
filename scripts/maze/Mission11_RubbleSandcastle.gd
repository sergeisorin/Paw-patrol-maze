extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 10
	mission_title = "Rubble and the Sandcastle"
	pup_id = "rubble"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Крепыш, давай построим замок из песка во дворе!", "duration": 3.5, "voice": "res://assets/audio/voice/m11_intro_ryder.wav"},
		{"speaker": "Крепыш", "text": "Крепыш строит! Поехали!", "duration": 3.0, "voice": "res://assets/audio/voice/m11_intro_rubble.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.6, 0.5, 0.25)

func _get_path_color() -> Color:
	return Color(0.9, 0.88, 0.75)

func _get_goal_sprite() -> String:
	return "goal_sandcastle.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Крепыш", "text": "Ура! Какой красивый замок! Я построил!", "duration": 3.0, "voice": "res://assets/audio/voice/m11_celeb_rubble.wav"},
		{"speaker": "Райдер", "text": "Потрясающий замок, Крепыш! Ты мастер строитель!", "duration": 3.0, "voice": "res://assets/audio/voice/m11_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
