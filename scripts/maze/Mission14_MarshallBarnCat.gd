extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 13
	mission_title = "Marshall and the Barn Cat"
	pup_id = "marshall"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Маршалл, в амбаре спрятался котёнок! Помоги его найти!", "duration": 3.5, "voice": "res://assets/audio/voice/m14_intro_ryder.wav"},
		{"speaker": "Маршал", "text": "Бегу спасать котёнка!", "duration": 3.0, "voice": "res://assets/audio/voice/m14_intro_marshall.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.5, 0.38, 0.22)

func _get_path_color() -> Color:
	return Color(0.88, 0.82, 0.68)

func _get_goal_sprite() -> String:
	return "goal_barn_cat.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Маршал", "text": "Ура! Котёнок найден! Какой пушистый!", "duration": 3.0, "voice": "res://assets/audio/voice/m14_celeb_marshall.wav"},
		{"speaker": "Райдер", "text": "Молодец, Маршалл! Котёнок очень благодарен!", "duration": 3.0, "voice": "res://assets/audio/voice/m14_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
