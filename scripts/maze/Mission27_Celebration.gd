extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 26
	mission_title = "The Great Celebration"
	pup_id = "chase"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Щенки, сегодня большой праздник! Все вместе идём на вечеринку!", "duration": 4.0, "voice": "res://assets/audio/voice/m27_intro_ryder.wav"},
		{"speaker": "Гонщик", "text": "Все щенки готовы! Побежали на праздник!", "duration": 3.0, "voice": "res://assets/audio/voice/m27_intro_chase.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.4, 0.3, 0.6)

func _get_path_color() -> Color:
	return Color(0.85, 0.82, 0.9)

func _get_goal_sprite() -> String:
	return "goal_party_hat.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Гонщик", "text": "Ура! Какой замечательный праздник! Мы лучшая команда!", "duration": 3.5, "voice": "res://assets/audio/voice/m27_celeb_chase.wav"},
		{"speaker": "Райдер", "text": "Вы все молодцы! Щенячий патруль — лучшая команда на свете!", "duration": 4.0, "voice": "res://assets/audio/voice/m27_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(2.0), "timeout")
	GameManager.complete_mission(mission_index)
	MissionManager.go_to_main_menu()
