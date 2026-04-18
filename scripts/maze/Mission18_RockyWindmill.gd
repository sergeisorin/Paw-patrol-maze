extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 17
	mission_title = "Rocky and the Windmill"
	pup_id = "rocky"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Рокки, мельница сломалась! Нужно её починить!", "duration": 3.5, "voice": "res://assets/audio/voice/m18_intro_ryder.wav"},
		{"speaker": "Рокки", "text": "Не выбрасывай, починим! Я знаю как!", "duration": 3.0, "voice": "res://assets/audio/voice/m18_intro_rocky.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(13, 11)

func _get_wall_color() -> Color:
	return Color(0.25, 0.5, 0.35)

func _get_path_color() -> Color:
	return Color(0.82, 0.88, 0.78)

func _get_goal_sprite() -> String:
	return "goal_windmill.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W,W,W],
		[W,P,P,C,P,P,P,P,W,D,W,G,W],
		[W,P,W,W,W,W,W,P,W,P,W,P,W],
		[W,P,W,P,P,C,P,P,P,P,P,P,W],
		[W,P,W,P,W,W,W,W,W,W,W,W,W],
		[W,P,W,P,P,P,C,P,P,P,P,D,W],
		[W,P,W,W,W,W,W,W,P,W,W,W,W],
		[W,C,P,P,P,P,P,P,P,P,P,P,W],
		[W,W,W,P,W,W,W,W,W,W,P,W,W],
		[W,S,P,P,C,P,P,D,W,P,P,W,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Рокки", "text": "Ура! Мельница крутится! Я починил!", "duration": 3.0, "voice": "res://assets/audio/voice/m18_celeb_rocky.wav"},
		{"speaker": "Райдер", "text": "Великолепно, Рокки! Мельница работает как новая!", "duration": 3.0, "voice": "res://assets/audio/voice/m18_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
