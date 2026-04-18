extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 16
	mission_title = "Rubble Builds the Bridge"
	pup_id = "rubble"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Крепыш, мост сломался! Нужно построить новый!", "duration": 3.5, "voice": "res://assets/audio/voice/m17_intro_ryder.wav"},
		{"speaker": "Крепыш", "text": "Крепыш построит! Мост будет лучше прежнего!", "duration": 3.0, "voice": "res://assets/audio/voice/m17_intro_rubble.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(13, 11)

func _get_wall_color() -> Color:
	return Color(0.55, 0.45, 0.2)

func _get_path_color() -> Color:
	return Color(0.9, 0.85, 0.72)

func _get_goal_sprite() -> String:
	return "goal_bridge.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W,W,W],
		[W,D,W,P,P,P,C,P,P,P,P,G,W],
		[W,P,W,P,W,W,W,W,W,P,W,W,W],
		[W,P,P,P,W,P,P,C,P,P,W,D,W],
		[W,W,W,W,W,P,W,W,W,W,W,P,W],
		[W,P,C,P,P,P,W,P,P,P,P,P,W],
		[W,P,W,W,W,W,W,P,W,P,W,W,W],
		[W,P,P,P,P,C,P,P,W,P,P,D,W],
		[W,W,W,P,W,W,W,W,W,W,P,W,W],
		[W,S,P,P,P,C,P,P,P,P,P,W,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Крепыш", "text": "Ура! Новый мост готов! Можно переходить!", "duration": 3.0, "voice": "res://assets/audio/voice/m17_celeb_rubble.wav"},
		{"speaker": "Райдер", "text": "Замечательно, Крепыш! Прочный и красивый мост!", "duration": 3.0, "voice": "res://assets/audio/voice/m17_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
