extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 0
	mission_title = "Chase and the Lost Balloon"
	pup_id = "chase"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Мальчик потерял шарик в парке!", "duration": 3.0, "voice": "res://assets/audio/voice/m1_intro_ryder.wav"},
		{"speaker": "Гонщик", "text": "Гонщик берётся за дело! Найдём шарик!", "duration": 3.0, "voice": "res://assets/audio/voice/m1_intro_chase.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.3, 0.5, 0.25)

func _get_path_color() -> Color:
	return Color(0.82, 0.8, 0.72)

func _get_goal_sprite() -> String:
	return "goal_balloon.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Гонщик", "text": "Мы нашли шарик! Ура!", "duration": 3.0, "voice": "res://assets/audio/voice/m1_celeb_chase.wav"},
		{"speaker": "Райдер", "text": "Отлично! Ты заработал Звезду Города!", "duration": 3.0, "voice": "res://assets/audio/voice/m1_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
