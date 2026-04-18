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
var _pause_layer: CanvasLayer = null
var _paused: bool = false

var MazeGridScript = preload("res://scripts/maze/MazeGrid.gd")
var MazePlayerScript = preload("res://scripts/maze/MazePlayer.gd")

func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS
	MissionManager.start_playing()
	AudioManager.play_music(_get_music_track())
	_play_intro()

func _play_intro() -> void:
	var intro_layer = _create_intro_backdrop()
	yield(get_tree().create_timer(2.0), "timeout")
	_play_intro_dialogue()
	yield(DialogueManager, "dialogue_finished")
	var fade_tween = Tween.new()
	intro_layer.add_child(fade_tween)
	fade_tween.interpolate_property(intro_layer, "modulate:a", 1.0, 0.0, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN)
	fade_tween.start()
	yield(fade_tween, "tween_all_completed")
	intro_layer.queue_free()
	_build_maze()

func _create_intro_backdrop() -> CanvasLayer:
	var layer = CanvasLayer.new()
	layer.layer = 80
	add_child(layer)

	var card = Control.new()
	card.anchor_right = 1.0
	card.anchor_bottom = 1.0
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(card)

	var data = GameManager.get_mission(mission_index)
	var zone = data.get("zone", "town")
	var zc = GameManager.get_zone_colors(zone)

	var bg = ColorRect.new()
	bg.color = zc.bg
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(bg)

	_add_intro_stripe(card, zc.accent, 0.0, 0.12)
	_add_intro_stripe(card, zc.accent, 0.88, 1.0)

	_spawn_intro_sparkles(card, zc.star)

	var pup_tex = load("res://assets/sprites/pups/" + pup_id + ".png")
	if pup_tex:
		var portrait = TextureRect.new()
		portrait.texture = pup_tex
		portrait.expand = true
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.anchor_left = 0.3
		portrait.anchor_right = 0.7
		portrait.anchor_top = 0.05
		portrait.anchor_bottom = 0.52
		portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(portrait)

	var title = Label.new()
	title.text = mission_title
	title.align = Label.ALIGN_CENTER
	title.valign = Label.VALIGN_CENTER
	title.anchor_left = 0.05
	title.anchor_right = 0.95
	title.anchor_top = 0.54
	title.anchor_bottom = 0.72
	title.add_font_override("font", GameManager.make_font(48))
	title.add_color_override("font_color", Color.white)
	card.add_child(title)

	var pup_info = GameManager.get_pup(pup_id)
	var name_label = Label.new()
	name_label.text = pup_info.get("name", "")
	name_label.align = Label.ALIGN_CENTER
	name_label.valign = Label.VALIGN_CENTER
	name_label.anchor_left = 0.2
	name_label.anchor_right = 0.8
	name_label.anchor_top = 0.73
	name_label.anchor_bottom = 0.85
	name_label.add_font_override("font", GameManager.make_font(36))
	name_label.add_color_override("font_color", zc.text_accent)
	card.add_child(name_label)

	var badge_tex = load("res://assets/sprites/objects/paw_badge.png")
	if badge_tex:
		for pos in [Vector2(0.04, 0.14), Vector2(0.89, 0.14), Vector2(0.04, 0.82), Vector2(0.89, 0.82)]:
			var badge = TextureRect.new()
			badge.texture = badge_tex
			badge.expand = true
			badge.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			badge.anchor_left = pos.x
			badge.anchor_right = pos.x + 0.07
			badge.anchor_top = pos.y
			badge.anchor_bottom = pos.y + 0.09
			badge.modulate = Color(zc.star.r, zc.star.g, zc.star.b, 0.5)
			badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
			card.add_child(badge)

	card.modulate = Color(1, 1, 1, 0)
	var tween = Tween.new()
	card.add_child(tween)
	tween.interpolate_property(card, "modulate:a", 0.0, 1.0, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

	return layer

func _add_intro_stripe(parent: Control, color: Color, top: float, bottom: float) -> void:
	var stripe = ColorRect.new()
	stripe.color = color
	stripe.anchor_right = 1.0
	stripe.anchor_top = top
	stripe.anchor_bottom = bottom
	stripe.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(stripe)

func _spawn_intro_sparkles(parent: Control, color: Color) -> void:
	var badge_tex = load("res://assets/sprites/objects/paw_badge.png")
	for i in range(14):
		var x = rand_range(0.03, 0.90)
		var y = rand_range(0.03, 0.90)
		var s = rand_range(0.02, 0.045)
		var sparkle
		if badge_tex:
			sparkle = TextureRect.new()
			sparkle.texture = badge_tex
			sparkle.expand = true
			sparkle.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		else:
			sparkle = ColorRect.new()
			sparkle.color = color
		sparkle.anchor_left = x
		sparkle.anchor_right = x + s
		sparkle.anchor_top = y
		sparkle.anchor_bottom = y + s
		var alpha = rand_range(0.12, 0.35)
		sparkle.modulate = Color(color.r, color.g, color.b, alpha)
		sparkle.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(sparkle)

		var tw = Tween.new()
		sparkle.add_child(tw)
		var delay = rand_range(0.0, 0.6)
		var peak = min(alpha * 3.0, 0.8)
		tw.interpolate_property(sparkle, "modulate:a", alpha, peak, 0.35, Tween.TRANS_SINE, Tween.EASE_IN_OUT, delay)
		tw.interpolate_property(sparkle, "modulate:a", peak, alpha, 0.35, Tween.TRANS_SINE, Tween.EASE_IN_OUT, delay + 0.35)
		tw.repeat = true
		tw.start()

func _play_intro_dialogue() -> void:
	DialogueManager.play_sequence([
		{"speaker": "Райдер", "text": "Нам нужна помощь!", "duration": 2.5, "voice": "res://assets/audio/voice/base_intro.wav"}
	])

func _get_maze_data() -> Array:
	return MazeGenerator.generate_for_mission(mission_index)

func _get_maze_size() -> Vector2:
	return MazeGenerator.maze_dimensions_for_level(mission_index)

func _get_wall_color() -> Color:
	return Color(0.35, 0.55, 0.3)

func _get_path_color() -> Color:
	return Color(0.85, 0.82, 0.7)

func _get_music_track() -> String:
	if mission_index % 2 == 1:
		return "adventure2"
	return "adventure"

func _get_tile_style() -> String:
	return "outdoor"

func _get_goal_sprite() -> String:
	return "goal_doghouse.png"

func _build_maze() -> void:
	var bg_layer = CanvasLayer.new()
	bg_layer.name = "MazeBG"
	bg_layer.layer = -1
	add_child(bg_layer)
	var bg_rect = ColorRect.new()
	bg_rect.color = _get_wall_color().darkened(0.15)
	bg_rect.anchor_right = 1.0
	bg_rect.anchor_bottom = 1.0
	bg_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg_layer.add_child(bg_rect)

	var maze_size = _get_maze_size()
	_maze = Node2D.new()
	_maze.name = "MazeGrid"
	_maze.set_script(MazeGridScript)
	add_child(_maze)

	var data = _get_maze_data()
	_maze.setup(int(maze_size.x), int(maze_size.y), data, _get_wall_color(), _get_path_color(), _get_tile_style(), _get_goal_sprite())

	if not _maze.is_connected("collectible_picked", self, "_on_collectible_picked"):
		_maze.connect("collectible_picked", self, "_on_collectible_picked")
	if not _maze.is_connected("goal_reached", self, "_on_goal_reached"):
		_maze.connect("goal_reached", self, "_on_goal_reached")
	_collectibles_picked = 0

	var pup_info = GameManager.get_pup(pup_id)
	var pup_color = pup_info.get("color", Color.blue)

	_player = Node2D.new()
	_player.name = "MazePlayer"
	_player.set_script(MazePlayerScript)
	add_child(_player)
	_player.setup(_maze, _maze.start_cell, pup_color, pup_id)

	_setup_camera()
	_create_goal_indicator()
	_setup_hints()

func _setup_camera() -> void:
	_camera = Camera2D.new()
	_camera.name = "MazeCamera"
	_camera.current = true
	_player.add_child(_camera)

	var maze_pixel_w = _maze.grid_width * _maze.CELL_SIZE
	var maze_pixel_h = _maze.grid_height * _maze.CELL_SIZE

	var viewport_w := 1920.0
	var viewport_h := 1080.0
	var usable_h := viewport_h * 0.92
	var zoom_x = float(maze_pixel_w) / viewport_w
	var zoom_y = float(maze_pixel_h) / usable_h
	var fit_zoom = max(zoom_x, zoom_y) * 1.08
	fit_zoom = clamp(fit_zoom, 0.65, 1.1)
	_camera.zoom = Vector2(fit_zoom, fit_zoom)

	var pad = _maze.CELL_SIZE * 2
	_camera.limit_left = -pad
	_camera.limit_top = -pad
	_camera.limit_right = maze_pixel_w + pad
	_camera.limit_bottom = maze_pixel_h + pad
	_camera.smoothing_enabled = true
	_camera.smoothing_speed = 8.0

func _create_goal_indicator() -> void:
	var goal_layer = CanvasLayer.new()
	goal_layer.name = "GoalUI"
	goal_layer.layer = 50
	add_child(goal_layer)

	var data = GameManager.get_mission(mission_index)

	var goal_label = Label.new()
	goal_label.text = data.get("goal_text", "")
	goal_label.align = Label.ALIGN_CENTER
	goal_label.anchor_left = 0.3
	goal_label.anchor_right = 0.7
	goal_label.anchor_top = 0.05
	goal_label.anchor_bottom = 0.11

	goal_label.add_font_override("font", GameManager.make_font(32))
	goal_label.add_color_override("font_color", Color(1.0, 0.95, 0.5))
	goal_layer.add_child(goal_label)

	var bone_row = HBoxContainer.new()
	bone_row.anchor_left = 0.0
	bone_row.anchor_right = 0.0
	bone_row.anchor_top = 0.0
	bone_row.anchor_bottom = 0.0
	bone_row.margin_left = 20
	bone_row.margin_top = 12
	bone_row.add_constant_override("separation", 10)
	bone_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	goal_layer.add_child(bone_row)

	var bone_tex = load("res://assets/sprites/objects/collectible_bone.png")
	if bone_tex:
		var bone_icon = TextureRect.new()
		bone_icon.texture = bone_tex
		bone_icon.rect_min_size = Vector2(52, 52)
		bone_icon.expand = true
		bone_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		bone_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bone_row.add_child(bone_icon)

	var count_chip = PanelContainer.new()
	count_chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var chip_bg = StyleBoxFlat.new()
	chip_bg.bg_color = Color(0.15, 0.12, 0.28, 0.96)
	chip_bg.corner_radius_top_left = 10
	chip_bg.corner_radius_top_right = 10
	chip_bg.corner_radius_bottom_left = 10
	chip_bg.corner_radius_bottom_right = 10
	chip_bg.content_margin_left = 12
	chip_bg.content_margin_right = 12
	chip_bg.content_margin_top = 8
	chip_bg.content_margin_bottom = 8
	count_chip.add_stylebox_override("panel", chip_bg)

	_collectible_label = Label.new()
	var count_font = GameManager.make_font(36)
	_collectible_label.add_font_override("font", count_font)
	_collectible_label.add_color_override("font_color", Color(1.0, 0.95, 0.5))
	_collectible_label.valign = Label.VALIGN_CENTER
	_collectible_label.align = Label.ALIGN_CENTER
	var count_box_w = count_font.get_string_size("99/99").x + 4
	_collectible_label.rect_min_size = Vector2(count_box_w, 44)
	count_chip.add_child(_collectible_label)
	bone_row.add_child(count_chip)
	_update_collectible_label()


func _setup_hints() -> void:
	HintManager.register_target(_player)
	_player.connect("moved", self, "_on_player_moved_hint")

func _on_player_moved_hint(_pos) -> void:
	HintManager.reset_timer(_player)

func _on_collectible_picked(_type: String) -> void:
	if not is_instance_valid(_maze):
		return
	var actual = _maze.get_collected_count()
	if actual <= _collectibles_picked:
		return
	var delta = actual - _collectibles_picked
	_collectibles_picked = actual
	AudioManager.play_sfx("bone_collect")
	GameManager.collectibles_total += delta
	_update_collectible_label()

func _update_collectible_label() -> void:
	if not is_instance_valid(_collectible_label):
		return
	var collected = _collectibles_picked
	var total = 0
	if is_instance_valid(_maze):
		collected = _maze.get_collected_count()
		total = _maze.get_total_collectibles()
		_collectibles_picked = collected
	var next_text = str(collected) + "/" + str(total)
	_collectible_label.text = next_text
	var chip = _collectible_label.get_parent()
	if chip:
		chip.update()
	_collectible_label.update()
	var row = chip.get_parent() if chip else null
	if row:
		row.queue_sort()

func _on_goal_reached() -> void:
	if _finishing:
		return
	_finishing = true
	_player.disable()
	HintManager.clear_all()
	AudioManager.play_sfx("reward")
	_player.play_victory_spin()
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

func _unhandled_input(event: InputEvent) -> void:
	if _finishing:
		return
	if event.is_action_pressed("back") or event.is_action_pressed("pause"):
		if _paused:
			_resume()
		else:
			_show_pause_menu()

func _show_pause_menu() -> void:
	if _paused:
		return
	_paused = true
	get_tree().paused = true

	_pause_layer = CanvasLayer.new()
	_pause_layer.layer = 92
	_pause_layer.pause_mode = PAUSE_MODE_PROCESS
	add_child(_pause_layer)

	var dim = ColorRect.new()
	dim.color = Color(0.0, 0.0, 0.0, 0.6)
	dim.anchor_right = 1.0
	dim.anchor_bottom = 1.0
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_pause_layer.add_child(dim)

	var vbox = VBoxContainer.new()
	vbox.anchor_left = 0.25
	vbox.anchor_right = 0.75
	vbox.anchor_top = 0.25
	vbox.anchor_bottom = 0.75
	vbox.alignment = VBoxContainer.ALIGN_CENTER
	vbox.add_constant_override("separation", 30)
	vbox.pause_mode = PAUSE_MODE_PROCESS
	_pause_layer.add_child(vbox)

	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.12, 0.3, 0.92)
	style.corner_radius_top_left = 24
	style.corner_radius_top_right = 24
	style.corner_radius_bottom_left = 24
	style.corner_radius_bottom_right = 24
	style.content_margin_left = 40
	style.content_margin_right = 40
	style.content_margin_top = 30
	style.content_margin_bottom = 30
	style.border_width_top = 4
	style.border_width_bottom = 4
	style.border_width_left = 4
	style.border_width_right = 4
	style.border_color = Color(1.0, 0.85, 0.2)
	panel.add_stylebox_override("panel", style)
	vbox.add_child(panel)

	var inner = VBoxContainer.new()
	inner.alignment = VBoxContainer.ALIGN_CENTER
	inner.add_constant_override("separation", 24)
	panel.add_child(inner)

	var title = Label.new()
	title.text = "ПАУЗА"
	title.align = Label.ALIGN_CENTER
	title.add_font_override("font", GameManager.make_font(48))
	title.add_color_override("font_color", Color(1.0, 0.95, 0.4))
	inner.add_child(title)

	var resume_btn = Button.new()
	resume_btn.text = "ПРОДОЛЖИТЬ"
	resume_btn.rect_min_size = Vector2(400, 80)
	resume_btn.add_font_override("font", GameManager.make_font(32))
	GameManager.apply_menu_button_styles(resume_btn)
	resume_btn.pause_mode = PAUSE_MODE_PROCESS
	resume_btn.connect("pressed", self, "_resume")
	inner.add_child(resume_btn)

	var restart_btn = Button.new()
	restart_btn.text = "НАЧАТЬ СНАЧАЛА"
	restart_btn.rect_min_size = Vector2(400, 80)
	restart_btn.add_font_override("font", GameManager.make_font(32))
	GameManager.apply_menu_button_styles(restart_btn)
	restart_btn.pause_mode = PAUSE_MODE_PROCESS
	restart_btn.connect("pressed", self, "_restart_from_beginning")
	inner.add_child(restart_btn)

	var menu_btn = Button.new()
	menu_btn.text = "В МЕНЮ"
	menu_btn.rect_min_size = Vector2(400, 80)
	menu_btn.add_font_override("font", GameManager.make_font(32))
	GameManager.apply_menu_button_styles(menu_btn)
	menu_btn.pause_mode = PAUSE_MODE_PROCESS
	menu_btn.connect("pressed", self, "_back_to_menu")
	inner.add_child(menu_btn)

	resume_btn.grab_focus()

func _resume() -> void:
	if not _paused:
		return
	_paused = false
	get_tree().paused = false
	if _pause_layer and is_instance_valid(_pause_layer):
		_pause_layer.queue_free()
		_pause_layer = null

func _back_to_menu() -> void:
	_paused = false
	get_tree().paused = false
	HintManager.clear_all()
	DialogueManager.hide_dialogue()
	if _pause_layer and is_instance_valid(_pause_layer):
		_pause_layer.queue_free()
		_pause_layer = null
	MissionManager.go_to_main_menu()

func _restart_from_beginning() -> void:
	_paused = false
	get_tree().paused = false
	HintManager.clear_all()
	DialogueManager.hide_dialogue()
	if _pause_layer and is_instance_valid(_pause_layer):
		_pause_layer.queue_free()
		_pause_layer = null
	GameManager.reset_game()
	MissionManager.load_mission(0)
