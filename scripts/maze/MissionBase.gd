extends Node2D

export var mission_index: int = 0
export var mission_title: String = ""
export var pup_id: String = "chase"

var _maze: Node2D = null
var _player: Node2D = null
var _camera: Camera2D = null
var _finishing: bool = false
var _reward_finished_flag: bool = false
var _collectibles_picked: int = 0
var _collectible_label: Label = null

var MazeGridScript = preload("res://scripts/maze/MazeGrid.gd")
var MazePlayerScript = preload("res://scripts/maze/MazePlayer.gd")

func _ready() -> void:
	MissionManager.start_playing()
	AudioManager.play_music("adventure")
	_play_intro()

func _play_intro() -> void:
	_show_mission_title()
	yield(get_tree().create_timer(2.0), "timeout")
	_play_intro_dialogue()
	yield(DialogueManager, "dialogue_finished")
	_build_maze()

func _show_mission_title() -> void:
	var layer = CanvasLayer.new()
	layer.layer = 80
	add_child(layer)

	var label = Label.new()
	label.text = mission_title
	label.align = Label.ALIGN_CENTER
	label.valign = Label.VALIGN_CENTER
	label.anchor_left = 0.0
	label.anchor_right = 1.0
	label.anchor_top = 0.35
	label.anchor_bottom = 0.65

	label.add_font_override("font", GameManager.make_font(48))
	label.add_color_override("font_color", Color.white)
	layer.add_child(label)

	var tween = Tween.new()
	label.add_child(tween)
	tween.interpolate_property(label, "modulate:a", 0.0, 1.0, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(label, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN, 1.5)
	tween.start()
	tween.connect("tween_all_completed", layer, "queue_free")

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Нам нужна помощь!", "duration": 2.5, "voice": "res://assets/audio/voice/base_intro.wav"}
	])

func _get_maze_data() -> Array:
	return []

func _get_maze_size() -> Vector2:
	return Vector2(11, 9)

func _get_wall_color() -> Color:
	return Color(0.35, 0.55, 0.3)

func _get_path_color() -> Color:
	return Color(0.85, 0.82, 0.7)

func _build_maze() -> void:
	var maze_size = _get_maze_size()
	_maze = Node2D.new()
	_maze.name = "MazeGrid"
	_maze.set_script(MazeGridScript)
	add_child(_maze)

	var data = _get_maze_data()
	_maze.setup(int(maze_size.x), int(maze_size.y), data, _get_wall_color(), _get_path_color())

	_maze.connect("collectible_picked", self, "_on_collectible_picked")
	_maze.connect("goal_reached", self, "_on_goal_reached")

	var pup_info = GameManager.get_pup(pup_id)
	var pup_color = pup_info.get("color", Color.blue)

	_player = Node2D.new()
	_player.name = "MazePlayer"
	_player.set_script(MazePlayerScript)
	add_child(_player)
	_player.setup(_maze, _maze.start_cell, pup_color)

	_setup_camera()
	_create_goal_indicator()
	_setup_hints()

func _setup_camera() -> void:
	_camera = Camera2D.new()
	_camera.name = "MazeCamera"
	_camera.current = true
	_camera.zoom = Vector2(1.15, 1.15)
	_player.add_child(_camera)

	var maze_pixel_w = _maze.grid_width * _maze.CELL_SIZE
	var maze_pixel_h = _maze.grid_height * _maze.CELL_SIZE
	_camera.limit_left = -int(_maze.CELL_SIZE * 0.5)
	_camera.limit_top = -int(_maze.CELL_SIZE * 0.5)
	_camera.limit_right = maze_pixel_w + int(_maze.CELL_SIZE * 0.5)
	_camera.limit_bottom = maze_pixel_h + int(_maze.CELL_SIZE * 0.5)
	_camera.smoothing_enabled = true
	_camera.smoothing_speed = 8.0

func _create_goal_indicator() -> void:
	var goal_layer = CanvasLayer.new()
	goal_layer.name = "GoalUI"
	goal_layer.layer = 50
	add_child(goal_layer)

	var goal_label = Label.new()
	var data = GameManager.get_mission(mission_index)
	goal_label.text = data.get("goal_text", "")
	goal_label.align = Label.ALIGN_CENTER
	goal_label.anchor_left = 0.3
	goal_label.anchor_right = 0.7
	goal_label.anchor_top = 0.02
	goal_label.anchor_bottom = 0.08

	goal_label.add_font_override("font", GameManager.make_font(32))
	goal_label.add_color_override("font_color", Color(1.0, 0.95, 0.5))
	goal_layer.add_child(goal_label)


func _setup_hints() -> void:
	HintManager.register_target(_player)
	_player.connect("moved", self, "_on_player_moved_hint")

func _on_player_moved_hint(_pos) -> void:
	HintManager.reset_timer(_player)

func _on_collectible_picked(type: String) -> void:
	_collectibles_picked += 1
	AudioManager.play_sfx("sparkle")
	GameManager.collectibles_total += 1
	_update_collectible_label()

func _update_collectible_label() -> void:
	if is_instance_valid(_collectible_label) and is_instance_valid(_maze):
		var collected = _maze.get_collected_count()
		var total = _maze.get_total_collectibles()
		_collectible_label.text = str(collected) + "/" + str(total)

func _on_goal_reached() -> void:
	if _finishing:
		return
	_finishing = true
	_player.set_process(false)
	HintManager.clear_all()
	AudioManager.play_sfx("reward")
	_reward_finished_flag = false
	RewardManager.connect("reward_finished", self, "_on_reward_finished", [], CONNECT_ONESHOT)
	RewardManager.play_chapter_complete()
	_play_celebration()

func _on_reward_finished(_type) -> void:
	_reward_finished_flag = true

func _play_celebration() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Отличная работа!", "duration": 2.5, "voice": "res://assets/audio/voice/base_celebration.wav"}
	])
	yield(DialogueManager, "dialogue_finished")
	if not _reward_finished_flag:
		yield(RewardManager, "reward_finished")
	yield(get_tree().create_timer(0.5), "timeout")
	MissionManager.finish_mission()

func _get_collected_text() -> String:
	if _maze:
		return str(_maze.get_collected_count()) + "/" + str(_maze.get_total_collectibles())
	return "0/0"
