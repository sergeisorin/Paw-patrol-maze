extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 4
	mission_title = "Rubble Fixes the Road"
	pup_id = "rubble"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Дорога к площадке заблокирована!", "duration": 3.0, "voice": "res://assets/audio/voice/m5_intro_ryder.wav"},
		{"speaker": "Крепыш", "text": "Крепыш всегда готов! Найдём инструменты!", "duration": 3.0, "voice": "res://assets/audio/voice/m5_intro_rubble.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.55, 0.5, 0.35)

func _get_path_color() -> Color:
	return Color(0.88, 0.85, 0.75)

func _get_goal_sprite() -> String:
	return "goal_toolbox.png"

func _get_tile_style() -> String:
	return "indoor"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Крепыш", "text": "Дорога починена! Дети могут играть!", "duration": 3.0, "voice": "res://assets/audio/voice/m5_celeb_rubble.wav"},
		{"speaker": "Райдер", "text": "Ты заработал Звезду Стройки!", "duration": 3.0, "voice": "res://assets/audio/voice/m5_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
