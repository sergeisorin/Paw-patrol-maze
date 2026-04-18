extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 24
	mission_title = "Chase and the Trophy"
	pup_id = "chase"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Гонщик, пропал кубок победителя! Найди его!", "duration": 3.5, "voice": "res://assets/audio/voice/m25_intro_ryder.wav"},
		{"speaker": "Гонщик", "text": "Гонщик берёт след! Кубок будет найден!", "duration": 3.0, "voice": "res://assets/audio/voice/m25_intro_chase.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(17, 13)

func _get_wall_color() -> Color:
	return Color(0.3, 0.35, 0.55)

func _get_path_color() -> Color:
	return Color(0.82, 0.82, 0.8)

func _get_goal_sprite() -> String:
	return "goal_trophy.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
		[W,W,W,W,W,P,P,P,P,C,P,P,P,C,P,G,W],
		[W,W,W,W,W,P,W,W,W,W,W,W,W,W,W,W,W],
		[W,W,W,W,W,P,P,P,P,C,P,P,P,P,W,W,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W,P,W,W,W],
		[W,W,W,W,W,P,P,P,P,C,P,P,P,P,P,D,W],
		[W,W,W,W,W,P,W,W,W,W,W,W,W,W,W,W,W],
		[W,W,W,D,P,P,P,P,P,C,P,P,P,P,W,W,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W,P,W,W,W],
		[W,W,W,W,W,W,W,P,P,P,C,P,P,P,P,D,W],
		[W,W,W,W,W,W,W,P,W,W,W,W,W,W,W,W,W],
		[W,S,P,P,C,P,P,P,P,D,W,W,W,W,W,W,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Гонщик", "text": "Ура! Кубок найден! Мы чемпионы!", "duration": 3.0, "voice": "res://assets/audio/voice/m25_celeb_chase.wav"},
		{"speaker": "Райдер", "text": "Потрясающе, Гонщик! Ты заслужил этот кубок!", "duration": 3.0, "voice": "res://assets/audio/voice/m25_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
