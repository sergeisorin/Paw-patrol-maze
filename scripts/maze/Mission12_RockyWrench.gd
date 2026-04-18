extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 11
	mission_title = "Rocky Finds the Wrench"
	pup_id = "rocky"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Рокки, потерялся гаечный ключ! Нужно его найти!", "duration": 3.5, "voice": "res://assets/audio/voice/m12_intro_ryder.wav"},
		{"speaker": "Рокки", "text": "Не выбрасывай, пригодится! Я найду ключ!", "duration": 3.0, "voice": "res://assets/audio/voice/m12_intro_rocky.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(11, 9)

func _get_wall_color() -> Color:
	return Color(0.3, 0.5, 0.3)

func _get_path_color() -> Color:
	return Color(0.82, 0.85, 0.78)

func _get_goal_sprite() -> String:
	return "goal_wrench.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W],
		[W,W,W,P,C,P,P,P,P,G,W],
		[W,W,W,P,W,W,W,W,W,W,W],
		[W,W,W,P,C,P,D,W,W,W,W],
		[W,W,W,W,W,P,W,W,W,W,W],
		[W,W,W,W,D,C,W,W,W,W,W],
		[W,W,W,W,W,P,W,W,W,W,W],
		[W,S,P,P,C,P,P,P,D,W,W],
		[W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Рокки", "text": "Ура! Нашёл ключ! Теперь всё починим!", "duration": 3.0, "voice": "res://assets/audio/voice/m12_celeb_rocky.wav"},
		{"speaker": "Райдер", "text": "Отлично, Рокки! Ты всегда находишь что нужно!", "duration": 3.0, "voice": "res://assets/audio/voice/m12_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
