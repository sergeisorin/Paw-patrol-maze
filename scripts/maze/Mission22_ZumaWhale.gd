extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 21
	mission_title = "Zuma and the Whale"
	pup_id = "zuma"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Зума, маленький кит заплыл на мелководье! Помоги ему!", "duration": 3.5, "voice": "res://assets/audio/voice/m22_intro_ryder.wav"},
		{"speaker": "Зума", "text": "Бедный китёнок! Я помогу ему вернуться в море!", "duration": 3.0, "voice": "res://assets/audio/voice/m22_intro_zuma.wav"},
	])


func _get_wall_color() -> Color:
	return Color(0.12, 0.35, 0.55)

func _get_path_color() -> Color:
	return Color(0.82, 0.88, 0.85)

func _get_goal_sprite() -> String:
	return "goal_whale.png"


func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Зума", "text": "Ура! Китёнок плывёт домой! Он счастлив!", "duration": 3.0, "voice": "res://assets/audio/voice/m22_celeb_zuma.wav"},
		{"speaker": "Райдер", "text": "Супер, Зума! Ты спас китёнка!", "duration": 3.0, "voice": "res://assets/audio/voice/m22_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
