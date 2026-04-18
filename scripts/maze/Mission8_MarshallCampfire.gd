extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 7
	mission_title = "Marshall and the Campfire"
	pup_id = "marshall"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Маршалл, на ферме кто-то оставил костёр! Помоги потушить его!", "duration": 3.5, "voice": "res://assets/audio/voice/m8_intro_ryder.wav"},
		{"speaker": "Маршал", "text": "Я готов! Бегу тушить костёр!", "duration": 3.0, "voice": "res://assets/audio/voice/m8_intro_marshall.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(9, 7)

func _get_wall_color() -> Color:
	return Color(0.5, 0.35, 0.2)

func _get_path_color() -> Color:
	return Color(0.85, 0.8, 0.65)

func _get_goal_sprite() -> String:
	return "goal_campfire.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W],
		[W,D,W,C,P,P,P,G,W],
		[W,P,W,P,W,W,W,W,W],
		[W,P,P,P,C,P,D,W,W],
		[W,W,W,W,W,P,W,W,W],
		[W,S,P,C,P,P,W,W,W],
		[W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Маршал", "text": "Ура! Костёр потушен! Я настоящий пожарный!", "duration": 3.0, "voice": "res://assets/audio/voice/m8_celeb_marshall.wav"},
		{"speaker": "Райдер", "text": "Отличная работа, Маршалл! Ты настоящий герой!", "duration": 3.0, "voice": "res://assets/audio/voice/m8_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
