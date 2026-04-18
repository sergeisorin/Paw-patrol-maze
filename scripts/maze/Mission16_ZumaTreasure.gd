extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 15
	mission_title = "Zuma and the Treasure Chest"
	pup_id = "zuma"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Зума, на пляже нашли карту сокровищ! Найди сундук!", "duration": 3.5, "voice": "res://assets/audio/voice/m16_intro_ryder.wav"},
		{"speaker": "Зума", "text": "Сокровища! Я нырну и найду!", "duration": 3.0, "voice": "res://assets/audio/voice/m16_intro_zuma.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.15, 0.4, 0.5)

func _get_path_color() -> Color:
	return Color(0.85, 0.9, 0.82)

func _get_goal_sprite() -> String:
	return "goal_treasure.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Зума", "text": "Ура! Сундук с сокровищами найден!", "duration": 3.0, "voice": "res://assets/audio/voice/m16_celeb_zuma.wav"},
		{"speaker": "Райдер", "text": "Потрясающе, Зума! Настоящие сокровища!", "duration": 3.0, "voice": "res://assets/audio/voice/m16_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
