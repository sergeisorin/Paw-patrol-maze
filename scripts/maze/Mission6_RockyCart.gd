extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 5
	mission_title = "Rocky's Recycling Rescue"
	pup_id = "rocky"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Тележка для уборки потерялась в саду!", "duration": 3.0, "voice": "res://assets/audio/voice/m6_intro_ryder.wav"},
		{"speaker": "Рокки", "text": "Не выбрасывай — используй! Найдём тележку!", "duration": 3.5, "voice": "res://assets/audio/voice/m6_intro_rocky.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.25, 0.5, 0.35)

func _get_path_color() -> Color:
	return Color(0.8, 0.85, 0.75)

func _get_goal_sprite() -> String:
	return "goal_cart.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Рокки", "text": "Тележка найдена! Парк будет чистым!", "duration": 3.0, "voice": "res://assets/audio/voice/m6_celeb_rocky.wav"},
		{"speaker": "Райдер", "text": "Ты заработал Звезду Переработки!", "duration": 3.0, "voice": "res://assets/audio/voice/m6_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
