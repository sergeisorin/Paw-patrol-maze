extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 25
	mission_title = "Marshall and the Fireworks"
	pup_id = "marshall"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Маршалл, сегодня праздник! Помоги найти фейерверки!", "duration": 3.5, "voice": "res://assets/audio/voice/m26_intro_ryder.wav"},
		{"speaker": "Маршал", "text": "Фейерверки! Будет красиво! Бегу!", "duration": 3.0, "voice": "res://assets/audio/voice/m26_intro_marshall.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(17, 15)

func _get_wall_color() -> Color:
	return Color(0.45, 0.3, 0.2)

func _get_path_color() -> Color:
	return Color(0.88, 0.82, 0.72)

func _get_goal_sprite() -> String:
	return "goal_fireworks.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
		[W,D,P,P,W,P,P,P,P,P,W,P,P,C,P,G,W],
		[W,W,W,P,W,P,W,W,W,P,W,W,W,W,W,P,W],
		[W,C,P,P,P,P,P,P,W,P,P,P,P,P,W,P,W],
		[W,W,W,W,W,W,W,P,W,W,W,W,W,P,W,P,W],
		[W,D,W,P,P,P,W,P,P,C,P,P,W,P,W,P,W],
		[W,P,W,P,W,P,W,W,W,W,W,P,W,P,W,P,W],
		[W,P,P,P,W,P,P,P,P,P,P,P,P,P,P,P,W],
		[W,W,W,P,W,W,W,W,W,P,W,W,W,W,W,W,W],
		[W,P,P,P,P,C,P,P,W,P,P,P,C,P,P,D,W],
		[W,P,W,W,W,W,W,P,W,W,W,W,W,W,W,W,W],
		[W,P,P,P,P,P,P,P,P,P,C,P,P,P,P,P,W],
		[W,W,W,P,W,W,W,W,W,W,W,W,W,W,W,P,W],
		[W,S,P,P,P,C,P,D,W,P,P,P,P,P,P,P,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Маршал", "text": "Ура! Фейерверки найдены! Запускаем!", "duration": 3.0, "voice": "res://assets/audio/voice/m26_celeb_marshall.wav"},
		{"speaker": "Райдер", "text": "Великолепно, Маршалл! Какой красивый салют!", "duration": 3.0, "voice": "res://assets/audio/voice/m26_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
