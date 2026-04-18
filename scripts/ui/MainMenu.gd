extends Control

var _play_button: Button = null
var _title_label: Label = null
var _mission_container: VBoxContainer = null

func _ready() -> void:
	AudioManager.play_music("menu")
	_build_ui()

func _build_ui() -> void:
	var bg_tex = load("res://assets/sprites/ui/menu_background.png")
	if bg_tex:
		var bg_sprite = TextureRect.new()
		bg_sprite.texture = bg_tex
		bg_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		bg_sprite.anchor_right = 1.0
		bg_sprite.anchor_bottom = 1.0
		add_child(bg_sprite)
	else:
		var bg = ColorRect.new()
		bg.color = Color(0.2, 0.35, 0.55)
		bg.anchor_right = 1.0
		bg.anchor_bottom = 1.0
		add_child(bg)

	var vbox = VBoxContainer.new()
	vbox.anchor_left = 0.2
	vbox.anchor_right = 0.8
	vbox.anchor_top = 0.05
	vbox.anchor_bottom = 0.95
	vbox.alignment = VBoxContainer.ALIGN_CENTER
	add_child(vbox)

	var logo_tex = load("res://assets/sprites/ui/paw_patrol_logo.png")
	if logo_tex:
		var logo = TextureRect.new()
		logo.texture = logo_tex
		logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		logo.rect_min_size = Vector2(400, 250)
		vbox.add_child(logo)

	var subtitle_panel = _make_text_panel()
	vbox.add_child(subtitle_panel)
	_title_label = Label.new()
	_title_label.text = "MAZE ADVENTURE"
	_title_label.align = Label.ALIGN_CENTER
	_title_label.add_font_override("font", GameManager.make_font(40))
	_title_label.add_color_override("font_color", Color.white)
	subtitle_panel.add_child(_title_label)

	var spacer = Control.new()
	spacer.rect_min_size = Vector2(0, 20)
	vbox.add_child(spacer)

	_play_button = Button.new()
	_play_button.text = _get_play_text()
	_play_button.rect_min_size = Vector2(400, 80)
	_play_button.add_font_override("font", GameManager.make_font(36))
	_play_button.connect("pressed", self, "_on_play_pressed")
	vbox.add_child(_play_button)

	var restart_btn = Button.new()
	restart_btn.text = "RESTART ALL LEVELS"
	restart_btn.rect_min_size = Vector2(400, 80)
	restart_btn.add_font_override("font", GameManager.make_font(36))
	restart_btn.connect("pressed", self, "_on_restart_all_pressed")
	vbox.add_child(restart_btn)

	_play_button.grab_focus()

	var spacer2 = Control.new()
	spacer2.rect_min_size = Vector2(0, 10)
	vbox.add_child(spacer2)

	var list_panel = _make_text_panel()
	vbox.add_child(list_panel)
	var list_vbox = VBoxContainer.new()
	list_vbox.alignment = VBoxContainer.ALIGN_CENTER
	list_panel.add_child(list_vbox)
	_build_mission_list(list_vbox)

	var badges_label = Label.new()
	badges_label.text = _get_badges_text()
	badges_label.align = Label.ALIGN_CENTER
	badges_label.add_font_override("font", GameManager.make_font(22, false))
	badges_label.add_color_override("font_color", Color(0.9, 0.95, 1.0))
	list_panel.add_child(badges_label)

	var spacer_quit = Control.new()
	spacer_quit.rect_min_size = Vector2(0, 16)
	vbox.add_child(spacer_quit)

	var quit_btn = Button.new()
	quit_btn.text = "QUIT"
	quit_btn.rect_min_size = Vector2(400, 64)
	quit_btn.add_font_override("font", GameManager.make_font(28))
	quit_btn.connect("pressed", self, "_on_quit_pressed")
	vbox.add_child(quit_btn)

func _make_text_panel() -> PanelContainer:
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.55)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	panel.add_stylebox_override("panel", style)
	return panel

func _build_mission_list(parent) -> void:
	_mission_container = VBoxContainer.new()
	_mission_container.alignment = VBoxContainer.ALIGN_CENTER
	parent.add_child(_mission_container)

	for i in range(GameManager.mission_data.size()):
		var data = GameManager.mission_data[i]
		var completed = i in GameManager.missions_completed
		var is_current = i == GameManager.current_mission
		var unlocked = i <= GameManager.current_mission

		var hbox = HBoxContainer.new()
		_mission_container.add_child(hbox)

		var status_label = Label.new()
		if completed:
			status_label.text = "[*] "
		elif is_current:
			status_label.text = "[>] "
		elif unlocked:
			status_label.text = "[ ] "
		else:
			status_label.text = "    "
		status_label.add_font_override("font", GameManager.make_font(20))
		status_label.add_color_override("font_color", Color.white if unlocked else Color(0.5, 0.5, 0.5))
		hbox.add_child(status_label)

		var mission_label = Label.new()
		mission_label.text = data.title
		mission_label.add_font_override("font", GameManager.make_font(20))
		if completed:
			mission_label.add_color_override("font_color", Color(0.5, 1.0, 0.5))
		elif is_current:
			mission_label.add_color_override("font_color", Color(1.0, 1.0, 0.5))
		elif unlocked:
			mission_label.add_color_override("font_color", Color.white)
		else:
			mission_label.add_color_override("font_color", Color(0.5, 0.5, 0.5))
		hbox.add_child(mission_label)

func _get_play_text() -> String:
	if GameManager.current_mission == 0 and GameManager.missions_completed.empty():
		return "START"
	elif GameManager.current_mission >= GameManager.mission_data.size():
		return "PLAY AGAIN"
	else:
		return "CONTINUE"

func _get_badges_text() -> String:
	if GameManager.badges_earned.empty():
		return ""
	return "Badges: " + PoolStringArray(GameManager.badges_earned).join(", ")

func _on_play_pressed() -> void:
	if GameManager.current_mission >= GameManager.mission_data.size():
		GameManager.reset_game()
	MissionManager.load_mission(GameManager.current_mission)

func _on_restart_all_pressed() -> void:
	GameManager.reset_game()
	MissionManager.load_mission(0)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm") and _play_button and _play_button.has_focus():
		_on_play_pressed()
