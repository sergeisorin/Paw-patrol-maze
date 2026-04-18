extends Node

signal mission_started(mission_index)
signal mission_transition_started
signal mission_transition_finished

enum Phase { INTRO, PLAYING, CELEBRATION, TRANSITION }

var current_phase: int = Phase.INTRO
var _transition_layer: CanvasLayer = null
var _completion_layer: CanvasLayer = null
var _finishing: bool = false

func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS

func load_mission(mission_index: int) -> void:
	var data = GameManager.get_mission(mission_index)
	if data.empty():
		push_error("Invalid mission index: " + str(mission_index))
		return

	emit_signal("mission_transition_started")
	current_phase = Phase.TRANSITION

	_fade_transition(true)
	yield(get_tree().create_timer(0.4), "timeout")

	var err = get_tree().change_scene(data.scene)
	if err != OK:
		push_error("Failed to load mission scene: " + data.scene)
		return

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	_fade_transition(false)

	current_phase = Phase.INTRO
	emit_signal("mission_started", mission_index)
	emit_signal("mission_transition_finished")

func start_playing() -> void:
	current_phase = Phase.PLAYING

func start_celebration() -> void:
	current_phase = Phase.CELEBRATION

func finish_mission() -> void:
	if _finishing:
		return
	_finishing = true
	_show_completion_card()
	yield(get_tree().create_timer(3.5), "timeout")
	_hide_completion_card()
	yield(get_tree().create_timer(0.5), "timeout")
	_finishing = false
	GameManager.advance_to_next_mission()

func go_to_main_menu() -> void:
	current_phase = Phase.INTRO
	_fade_transition(true)
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().change_scene("res://scenes/ui/MainMenu.tscn")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	_fade_transition(false)

func _fade_transition(fade_in: bool) -> void:
	if fade_in:
		if _transition_layer and is_instance_valid(_transition_layer):
			_transition_layer.queue_free()
		_transition_layer = CanvasLayer.new()
		_transition_layer.layer = 95
		add_child(_transition_layer)
		var rect = ColorRect.new()
		rect.name = "FadeRect"
		rect.color = Color(0.1, 0.08, 0.2, 0.0)
		rect.anchor_right = 1.0
		rect.anchor_bottom = 1.0
		rect.mouse_filter = Control.MOUSE_FILTER_STOP
		_transition_layer.add_child(rect)
		var tween = Tween.new()
		rect.add_child(tween)
		tween.interpolate_property(rect, "color:a", 0.0, 1.0, 0.35, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.start()
	else:
		if _transition_layer and is_instance_valid(_transition_layer):
			var rect = _transition_layer.get_node_or_null("FadeRect")
			if rect:
				rect.color.a = 1.0
				var tween = Tween.new()
				rect.add_child(tween)
				tween.interpolate_property(rect, "color:a", 1.0, 0.0, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
				tween.start()
				tween.connect("tween_all_completed", _transition_layer, "queue_free")

func _show_completion_card() -> void:
	if _completion_layer and is_instance_valid(_completion_layer):
		_completion_layer.queue_free()

	_completion_layer = CanvasLayer.new()
	_completion_layer.layer = 85
	add_child(_completion_layer)

	var card = Control.new()
	card.name = "CompletionCard"
	card.anchor_right = 1.0
	card.anchor_bottom = 1.0
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_completion_layer.add_child(card)

	var mi = GameManager.current_mission
	var data = GameManager.get_mission(mi)
	var zone = data.get("zone", "town")
	var pup_id = data.get("pup", "chase")
	var badge_name = data.get("badge", "")
	var zc = GameManager.get_zone_colors(zone)

	var bg = ColorRect.new()
	bg.color = zc.bg
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(bg)

	_add_card_stripe(card, zc.accent, 0.0, 0.1)
	_add_card_stripe(card, zc.accent, 0.9, 1.0)

	var praise = Label.new()
	praise.text = "Молодец!"
	praise.align = Label.ALIGN_CENTER
	praise.valign = Label.VALIGN_CENTER
	praise.anchor_left = 0.1
	praise.anchor_right = 0.9
	praise.anchor_top = 0.05
	praise.anchor_bottom = 0.16
	praise.add_font_override("font", GameManager.make_font(52))
	praise.add_color_override("font_color", Color(1.0, 0.95, 0.4))
	card.add_child(praise)

	var badge_tex = load("res://assets/sprites/objects/paw_badge.png")
	if badge_tex:
		var badge_img = TextureRect.new()
		badge_img.texture = badge_tex
		badge_img.expand = true
		badge_img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		badge_img.anchor_left = 0.25
		badge_img.anchor_right = 0.75
		badge_img.anchor_top = 0.15
		badge_img.anchor_bottom = 0.6
		badge_img.modulate = zc.star
		badge_img.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(badge_img)

	var pup_tex = load("res://assets/sprites/pups/" + pup_id + ".png")
	if pup_tex:
		var portrait = TextureRect.new()
		portrait.texture = pup_tex
		portrait.expand = true
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.anchor_left = 0.62
		portrait.anchor_right = 0.92
		portrait.anchor_top = 0.42
		portrait.anchor_bottom = 0.82
		portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(portrait)

	if badge_name != "":
		var badge_label = Label.new()
		badge_label.text = badge_name
		badge_label.align = Label.ALIGN_CENTER
		badge_label.valign = Label.VALIGN_CENTER
		badge_label.anchor_left = 0.05
		badge_label.anchor_right = 0.65
		badge_label.anchor_top = 0.62
		badge_label.anchor_bottom = 0.78
		badge_label.add_font_override("font", GameManager.make_font(40))
		badge_label.add_color_override("font_color", zc.text_accent)
		card.add_child(badge_label)

	_spawn_card_sparkles(card, zc.star, 12)

	card.modulate = Color(1, 1, 1, 0)
	var tween = Tween.new()
	card.add_child(tween)
	tween.interpolate_property(card, "modulate:a", 0.0, 1.0, 0.4, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()

func _hide_completion_card() -> void:
	if _completion_layer and is_instance_valid(_completion_layer):
		var card = _completion_layer.get_node_or_null("CompletionCard")
		if card:
			var tween = Tween.new()
			card.add_child(tween)
			tween.interpolate_property(card, "modulate:a", 1.0, 0.0, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN)
			tween.start()
			tween.connect("tween_all_completed", _completion_layer, "queue_free")

func _add_card_stripe(parent: Control, color: Color, top: float, bottom: float) -> void:
	var stripe = ColorRect.new()
	stripe.color = color
	stripe.anchor_right = 1.0
	stripe.anchor_top = top
	stripe.anchor_bottom = bottom
	stripe.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(stripe)

func _spawn_card_sparkles(parent: Control, color: Color, count: int) -> void:
	var badge_tex = load("res://assets/sprites/objects/paw_badge.png")
	for i in range(count):
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
		var delay = rand_range(0.0, 1.0)
		var peak = min(alpha * 3.0, 0.85)
		tw.interpolate_property(sparkle, "modulate:a", alpha, peak, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, delay)
		tw.interpolate_property(sparkle, "modulate:a", peak, alpha, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, delay + 0.4)
		tw.repeat = true
		tw.start()
