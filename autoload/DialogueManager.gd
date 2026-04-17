extends Node

signal dialogue_started
signal dialogue_line_shown(speaker, text)
signal dialogue_finished

var _dialogue_box: Control = null
var _dialogue_layer: CanvasLayer = null
var _is_playing: bool = false
var _current_queue: Array = []
var _voice_player: AudioStreamPlayer = null

func _ready() -> void:
	_voice_player = AudioStreamPlayer.new()
	_voice_player.volume_db = 3
	add_child(_voice_player)

func play_sequence(lines: Array) -> void:
	_current_queue = lines.duplicate()
	_is_playing = true
	emit_signal("dialogue_started")
	_play_next_line()

func _play_next_line() -> void:
	if _current_queue.empty():
		_is_playing = false
		_fade_and_hide()
		emit_signal("dialogue_finished")
		return

	var line = _current_queue.pop_front()
	var speaker = line.get("speaker", "")
	var text = line.get("text", "")
	var duration = line.get("duration", 3.0)
	var icon = line.get("icon", "")
	var voice = line.get("voice", "")

	emit_signal("dialogue_line_shown", speaker, text)
	_show_visual_dialogue(speaker, text, icon)
	_play_voice(voice)

	if voice != "" and _voice_player.stream:
		var voice_duration = _voice_player.stream.get_length()
		if voice_duration > 0:
			duration = max(duration, voice_duration + 0.5)

	yield(get_tree().create_timer(duration), "timeout")
	_play_next_line()

func say(speaker: String, text: String, duration: float = 3.0, voice: String = "") -> void:
	play_sequence([{"speaker": speaker, "text": text, "duration": duration, "voice": voice}])

func _play_voice(voice_path: String) -> void:
	if voice_path == "":
		return
	_voice_player.stop()
	var stream = load(voice_path)
	if stream:
		_voice_player.stream = stream
		_voice_player.play()

func _show_visual_dialogue(speaker: String, text: String, icon: String) -> void:
	if _dialogue_layer and is_instance_valid(_dialogue_layer):
		_dialogue_layer.queue_free()
		_dialogue_box = null

	_dialogue_layer = CanvasLayer.new()
	_dialogue_layer.layer = 90
	add_child(_dialogue_layer)

	_dialogue_box = _create_dialogue_ui(speaker, text)
	_dialogue_layer.add_child(_dialogue_box)

	var tween = Tween.new()
	_dialogue_box.add_child(tween)
	tween.interpolate_property(_dialogue_box, "modulate:a", 0.0, 1.0, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func _create_dialogue_ui(speaker: String, text: String) -> Control:
	var panel = PanelContainer.new()
	panel.anchor_left = 0.0
	panel.anchor_right = 1.0
	panel.anchor_top = 0.88
	panel.anchor_bottom = 1.0

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.25, 0.92)
	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 0
	style.corner_radius_bottom_left = 0
	style.corner_radius_bottom_right = 0
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	style.border_width_top = 3
	style.border_width_bottom = 0
	style.border_width_left = 0
	style.border_width_right = 0
	style.border_color = Color(1.0, 0.85, 0.2)
	panel.add_stylebox_override("panel", style)

	var hbox = HBoxContainer.new()
	hbox.add_constant_override("separation", 16)
	panel.add_child(hbox)

	if speaker != "":
		var speaker_label = Label.new()
		speaker_label.text = speaker + ":"
		speaker_label.add_font_override("font", GameManager.make_font(26))
		speaker_label.add_color_override("font_color", Color(1.0, 0.85, 0.2))
		speaker_label.valign = Label.VALIGN_CENTER
		hbox.add_child(speaker_label)

	var text_label = Label.new()
	text_label.text = text
	text_label.autowrap = true
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_label.add_font_override("font", GameManager.make_font(24, false))
	text_label.add_color_override("font_color", Color.white)
	text_label.valign = Label.VALIGN_CENTER
	hbox.add_child(text_label)

	return panel

func _fade_and_hide() -> void:
	if _dialogue_box and is_instance_valid(_dialogue_box):
		var fade_tween = Tween.new()
		_dialogue_box.add_child(fade_tween)
		fade_tween.interpolate_property(_dialogue_box, "modulate:a", _dialogue_box.modulate.a, 0.0, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN)
		fade_tween.start()
		fade_tween.connect("tween_all_completed", self, "_on_fade_complete")
	else:
		_cleanup_dialogue_layer()

func _on_fade_complete() -> void:
	_cleanup_dialogue_layer()

func _cleanup_dialogue_layer() -> void:
	if _dialogue_layer and is_instance_valid(_dialogue_layer):
		_dialogue_layer.queue_free()
		_dialogue_layer = null
		_dialogue_box = null

func hide_dialogue() -> void:
	_current_queue.clear()
	_is_playing = false
	_voice_player.stop()
	_cleanup_dialogue_layer()

func is_playing() -> bool:
	return _is_playing
