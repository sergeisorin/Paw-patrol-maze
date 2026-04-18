extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 2
	mission_title = "Skye and the Butterfly Garden"
	pup_id = "skye"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Котёнок заблудился в саду бабочек!", "duration": 3.0, "voice": "res://assets/audio/voice/m3_intro_ryder.wav"},
		{"speaker": "Скай", "text": "Этот щенок полетит! Найдём котёнка!", "duration": 3.0, "voice": "res://assets/audio/voice/m3_intro_skye.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.6, 0.35, 0.55)

func _get_path_color() -> Color:
	return Color(0.85, 0.9, 0.75)

func _get_goal_sprite() -> String:
	return "goal_kitten.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Скай", "text": "Котёнок найден! Мур-мур!", "duration": 3.0, "voice": "res://assets/audio/voice/m3_celeb_skye.wav"},
		{"speaker": "Райдер", "text": "Ты заработал Звезду Сада!", "duration": 3.0, "voice": "res://assets/audio/voice/m3_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
