extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 19
	mission_title = "Marshall and the Cookie Jar"
	pup_id = "marshall"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Маршалл, на кухне пропала банка с печеньем! Помоги найти!", "duration": 3.5, "voice": "res://assets/audio/voice/m20_intro_ryder.wav"},
		{"speaker": "Маршал", "text": "Печенье! Я найду банку! Бегу!", "duration": 3.0, "voice": "res://assets/audio/voice/m20_intro_marshall.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(15, 11)

func _get_wall_color() -> Color:
	return Color(0.5, 0.35, 0.25)

func _get_path_color() -> Color:
	return Color(0.9, 0.85, 0.72)

func _get_goal_sprite() -> String:
	return "goal_cookie_jar.png"

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
		[W,D,P,P,P,P,P,P,P,P,C,P,P,G,W],
		[W,W,W,W,W,W,W,W,P,W,W,W,W,W,W],
		[W,W,W,W,W,P,C,P,P,P,P,D,W,W,W],
		[W,W,W,W,W,P,W,W,W,W,W,W,W,W,W],
		[W,W,P,C,P,P,P,C,P,P,W,W,W,W,W],
		[W,W,W,W,W,W,W,W,P,W,W,W,W,W,W],
		[W,W,W,W,W,P,P,C,P,P,D,W,W,W,W],
		[W,W,W,W,W,P,W,W,W,W,W,W,W,W,W],
		[W,S,P,C,P,P,W,W,W,W,W,W,W,W,W],
		[W,W,W,W,W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Маршал", "text": "Ура! Нашёл банку с печеньем! Вкусняшки!", "duration": 3.0, "voice": "res://assets/audio/voice/m20_celeb_marshall.wav"},
		{"speaker": "Райдер", "text": "Молодец, Маршалл! Теперь можно угощаться!", "duration": 3.0, "voice": "res://assets/audio/voice/m20_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
