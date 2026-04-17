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

func _get_maze_size() -> Vector2:
	return Vector2(13, 11)

func _get_wall_color() -> Color:
	return Color(0.25, 0.5, 0.35)

func _get_path_color() -> Color:
	return Color(0.8, 0.85, 0.75)

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W,W,W],
		[W,P,P,P,P,C,W,P,P,P,P,G,W],
		[W,P,W,W,W,P,W,P,W,W,W,P,W],
		[W,P,P,P,W,P,P,P,W,P,P,P,W],
		[W,W,W,P,W,W,W,W,W,P,W,W,W],
		[W,C,P,P,P,P,P,C,P,P,P,D,W],
		[W,P,W,W,W,P,W,W,W,W,W,P,W],
		[W,P,W,D,P,P,W,P,P,C,W,P,W],
		[W,P,W,P,W,W,W,P,W,P,W,P,W],
		[W,S,P,P,P,P,P,P,W,P,P,P,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Рокки", "text": "Тележка найдена! Парк будет чистым!", "duration": 3.0, "voice": "res://assets/audio/voice/m6_celeb_rocky.wav"},
		{"speaker": "Райдер", "text": "Ты заработал Звезду Переработки!", "duration": 3.0, "voice": "res://assets/audio/voice/m6_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
