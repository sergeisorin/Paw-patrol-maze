extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 8
	mission_title = "Skye Finds the Lost Bird"
	pup_id = "skye"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Скай, в саду потерялась маленькая птичка! Помоги найти её домик!", "duration": 3.5, "voice": "res://assets/audio/voice/m9_intro_ryder.wav"},
		{"speaker": "Скай", "text": "Полетели! Я найду птичкин домик!", "duration": 3.0, "voice": "res://assets/audio/voice/m9_intro_skye.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(9, 7)

func _get_wall_color() -> Color:
	return Color(0.55, 0.3, 0.45)

func _get_path_color() -> Color:
	return Color(0.88, 0.85, 0.78)

func _get_goal_sprite() -> String:
	return "goal_birdhouse.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W],
		[W,P,P,C,P,C,P,G,W],
		[W,P,W,W,W,W,W,W,W],
		[W,C,P,P,D,W,W,W,W],
		[W,P,W,W,W,W,W,W,W],
		[W,S,P,D,W,W,W,W,W],
		[W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Скай", "text": "Ура! Птичка дома! Как я рада!", "duration": 3.0, "voice": "res://assets/audio/voice/m9_celeb_skye.wav"},
		{"speaker": "Райдер", "text": "Молодец, Скай! Птичка очень счастлива!", "duration": 3.0, "voice": "res://assets/audio/voice/m9_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
