extends "res://scripts/maze/MissionBase.gd"

func _ready() -> void:
	mission_index = 1
	mission_title = "Marshall Brings the Water Hose"
	pup_id = "marshall"
	._ready()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Фермер Юми нужна вода для цветов!", "duration": 3.0, "voice": "res://assets/audio/voice/m2_intro_ryder.wav"},
		{"speaker": "Маршал", "text": "Я горю от нетерпения! Найдём шланг!", "duration": 3.0, "voice": "res://assets/audio/voice/m2_intro_marshall.wav"},
	])

func _get_maze_size() -> Vector2:
	return Vector2(11, 9)

func _get_wall_color() -> Color:
	return Color(0.6, 0.4, 0.2)

func _get_path_color() -> Color:
	return Color(0.9, 0.85, 0.7)

func _get_maze_data() -> Array:
	var W = 0; var P = 1; var S = 2; var G = 3; var C = 4; var D = 5
	return [
		[W,W,W,W,W,W,W,W,W,W,W],
		[W,P,P,C,W,P,P,P,C,G,W],
		[W,P,W,P,W,P,W,W,W,P,W],
		[W,P,W,P,P,P,P,D,W,P,W],
		[W,P,W,W,W,W,W,P,W,P,W],
		[W,P,P,P,P,P,W,P,P,P,W],
		[W,W,W,W,W,P,W,W,W,P,W],
		[W,S,P,P,P,P,C,P,D,P,W],
		[W,W,W,W,W,W,W,W,W,W,W],
	]

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Маршал", "text": "Цветы спасены! Отлично!", "duration": 3.0, "voice": "res://assets/audio/voice/m2_celeb_marshall.wav"},
		{"speaker": "Райдер", "text": "Ты заработал Звезду Фермы!", "duration": 3.0, "voice": "res://assets/audio/voice/m2_celeb_ryder.wav"},
	])
	yield(DialogueManager, "dialogue_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	MissionManager.finish_mission()
