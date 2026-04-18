extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 18
	mission_title = "Chase and the Fire Truck"
	pup_id = "chase"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Гонщик, пожарная машина потерялась в городе! Найди её!", "duration": 3.5, "voice": "res://assets/audio/voice/m19_intro_ryder.wav"},
		{"speaker": "Гонщик", "text": "Гонщик на задании! Найду машину!", "duration": 3.0, "voice": "res://assets/audio/voice/m19_intro_chase.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(15, 11)

func _get_wall_color() -> Color:
	return Color(0.3, 0.35, 0.5)

func _get_path_color() -> Color:
	return Color(0.85, 0.82, 0.78)

func _get_goal_sprite() -> String:
	return "goal_firetruck.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
		[W,D,W,C,P,P,P,P,P,P,P,P,P,G,W],
		[W,P,W,P,W,W,W,W,W,W,W,W,P,W,W],
		[W,P,P,P,W,P,P,C,P,P,P,P,P,W,W],
		[W,W,W,W,W,P,W,W,W,W,W,W,W,W,W],
		[W,P,P,C,P,P,W,P,P,C,P,P,P,D,W],
		[W,P,W,W,W,W,W,P,W,W,W,W,P,W,W],
		[W,P,P,P,P,C,P,P,W,D,P,P,P,W,W],
		[W,W,W,P,W,W,W,W,W,W,W,P,W,W,W],
		[W,S,P,P,P,P,P,P,P,P,P,P,W,W,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Гонщик", "text": "Ура! Пожарная машина найдена!", "duration": 3.0, "voice": "res://assets/audio/voice/m19_celeb_chase.wav"},
		{"speaker": "Райдер", "text": "Отличная работа, Гонщик! Машина снова на месте!", "duration": 3.0, "voice": "res://assets/audio/voice/m19_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
