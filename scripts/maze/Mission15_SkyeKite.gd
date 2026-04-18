extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 14
	mission_title = "Skye and the Kite"
	pup_id = "skye"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Скай, воздушный змей улетел! Помоги поймать!", "duration": 3.5, "voice": "res://assets/audio/voice/m15_intro_ryder.wav"},
		{"speaker": "Скай", "text": "Я поймаю змея! Полетели!", "duration": 3.0, "voice": "res://assets/audio/voice/m15_intro_skye.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(13, 11)

func _get_wall_color() -> Color:
	return Color(0.5, 0.3, 0.5)

func _get_path_color() -> Color:
	return Color(0.88, 0.85, 0.82)

func _get_goal_sprite() -> String:
	return "goal_kite.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W,W,W],
		[W,D,W,C,P,P,P,P,P,P,P,G,W],
		[W,P,W,P,W,W,W,W,W,W,P,W,W],
		[W,P,P,P,W,P,P,C,P,P,P,W,W],
		[W,W,W,W,W,P,W,W,W,W,W,W,W],
		[W,C,P,P,P,P,W,P,P,P,D,W,W],
		[W,P,W,W,W,W,W,P,W,W,W,W,W],
		[W,P,P,C,P,P,P,P,W,P,P,D,W],
		[W,W,W,W,W,P,W,W,W,P,W,W,W],
		[W,S,P,P,C,P,P,P,P,P,W,W,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Скай", "text": "Ура! Змей пойман! Какой красивый!", "duration": 3.0, "voice": "res://assets/audio/voice/m15_celeb_skye.wav"},
		{"speaker": "Райдер", "text": "Прекрасно, Скай! Ты летаешь лучше всех!", "duration": 3.0, "voice": "res://assets/audio/voice/m15_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
