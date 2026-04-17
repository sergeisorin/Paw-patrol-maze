extends Node

signal reward_started(reward_type)
signal reward_finished(reward_type)

var _reward_layer: CanvasLayer = null
var _particles_container: Node2D = null

func _ready() -> void:
	_setup_reward_layer()

func _setup_reward_layer() -> void:
	_reward_layer = CanvasLayer.new()
	_reward_layer.layer = 100
	add_child(_reward_layer)
	_particles_container = Node2D.new()
	_particles_container.name = "ParticlesContainer"
	_reward_layer.add_child(_particles_container)

func play_tap_reward(position: Vector2) -> void:
	_spawn_star_burst(position, 5)
	AudioManager.play_sfx("sparkle")

func play_task_complete(position: Vector2) -> void:
	_spawn_star_burst(position, 12)
	_play_confetti()
	AudioManager.play_sfx("reward")
	emit_signal("reward_started", "task_complete")
	yield(get_tree().create_timer(1.5), "timeout")
	emit_signal("reward_finished", "task_complete")

func play_chapter_complete() -> void:
	emit_signal("reward_started", "chapter_complete")
	AudioManager.play_sfx("cheer")
	AudioManager.play_sfx("confetti")
	_flash_screen(Color(1.0, 1.0, 0.8), 0.3)
	for i in range(5):
		var x = rand_range(150, 1770)
		var y = rand_range(250, 550)
		_spawn_star_burst(Vector2(x, y), 20)
		_play_confetti()
		yield(get_tree().create_timer(0.3), "timeout")
	yield(get_tree().create_timer(2.0), "timeout")
	emit_signal("reward_finished", "chapter_complete")

func _spawn_star_burst(pos: Vector2, count: int) -> void:
	for i in range(count):
		var star = _create_star()
		star.position = pos
		_particles_container.add_child(star)
		_animate_star(star)

func _create_star() -> Node2D:
	var star = Node2D.new()
	var sprite = Sprite.new()

	var px_size = 28
	var img = Image.new()
	img.create(px_size, px_size, false, Image.FORMAT_RGBA8)
	img.lock()
	var center = Vector2(px_size / 2.0, px_size / 2.0)
	var outer_r = px_size * 0.42
	var inner_r = outer_r * 0.4
	var colors = [Color.yellow, Color.gold, Color(1.0, 0.5, 0.8), Color.cyan, Color(0.6, 1.0, 0.4), Color.white]
	var c = colors[randi() % colors.size()]

	var verts = []
	for i in range(10):
		var angle = (float(i) / 10.0) * TAU - PI / 2
		var r = outer_r if i % 2 == 0 else inner_r
		verts.append(Vector2(center.x + cos(angle) * r, center.y + sin(angle) * r))

	for x in range(px_size):
		for y in range(px_size):
			var p = Vector2(x, y)
			var dist = p.distance_to(center)
			if _point_in_polygon(p, verts):
				var alpha = clamp(1.0 - (dist / outer_r) * 0.3, 0.5, 1.0)
				img.set_pixel(x, y, Color(c.r, c.g, c.b, alpha))
	img.unlock()

	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	sprite.texture = tex
	star.add_child(sprite)
	return star

func _point_in_polygon(point: Vector2, verts: Array) -> bool:
	var n = verts.size()
	var inside = false
	var j = n - 1
	for i in range(n):
		var vi = verts[i]
		var vj = verts[j]
		if ((vi.y > point.y) != (vj.y > point.y)) and \
			(point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x):
			inside = not inside
		j = i
	return inside

func _animate_star(star: Node2D) -> void:
	var angle = rand_range(0, TAU)
	var distance = rand_range(80, 240)
	var target = star.position + Vector2(cos(angle), sin(angle)) * distance
	var duration = rand_range(0.5, 1.0)

	var tween = Tween.new()
	star.add_child(tween)
	tween.interpolate_property(star, "position", star.position, target, duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(star, "modulate:a", 1.0, 0.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration * 0.5)
	tween.interpolate_property(star, "scale", Vector2.ONE, Vector2(0.1, 0.1), duration, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	tween.connect("tween_all_completed", star, "queue_free")

func _flash_screen(color: Color, duration: float) -> void:
	var flash = ColorRect.new()
	flash.color = Color(color.r, color.g, color.b, 0.5)
	flash.anchor_right = 1.0
	flash.anchor_bottom = 1.0
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var flash_layer = CanvasLayer.new()
	flash_layer.layer = 99
	add_child(flash_layer)
	flash_layer.add_child(flash)
	var flash_tween = Tween.new()
	flash.add_child(flash_tween)
	flash_tween.interpolate_property(flash, "color:a", 0.5, 0.0, duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	flash_tween.start()
	flash_tween.connect("tween_all_completed", flash_layer, "queue_free")

func _play_confetti() -> void:
	for i in range(30):
		var confetti = _create_confetti_piece()
		confetti.position = Vector2(rand_range(100, 1820), -20)
		_particles_container.add_child(confetti)
		_animate_confetti(confetti)

func _create_confetti_piece() -> Sprite:
	var piece = Sprite.new()
	var w = int(rand_range(10, 22))
	var h = int(rand_range(10, 22))
	var img = Image.new()
	img.create(w, h, false, Image.FORMAT_RGBA8)
	var colors = [
		Color(1.0, 0.3, 0.3), Color(0.3, 0.5, 1.0), Color(0.3, 0.9, 0.4),
		Color(1.0, 0.9, 0.2), Color(1.0, 0.4, 0.8), Color(0.4, 0.9, 0.9),
		Color(1.0, 0.6, 0.2), Color(0.7, 0.4, 1.0)
	]
	var c = colors[randi() % colors.size()]
	img.lock()
	for px in range(w):
		for py in range(h):
			var edge = min(min(px, w - 1 - px), min(py, h - 1 - py))
			var brightness = 1.0 if edge > 1 else 0.85
			img.set_pixel(px, py, Color(c.r * brightness, c.g * brightness, c.b * brightness))
	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	piece.texture = tex
	return piece

func _animate_confetti(piece: Sprite) -> void:
	var target_y = 1100
	var drift_x = rand_range(-100, 100)
	var duration = rand_range(1.5, 3.0)
	var target_pos = piece.position + Vector2(drift_x, target_y)

	var tween = Tween.new()
	piece.add_child(tween)
	tween.interpolate_property(piece, "position", piece.position, target_pos, duration, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.interpolate_property(piece, "rotation_degrees", 0, rand_range(-360, 360), duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(piece, "modulate:a", 1.0, 0.0, duration * 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN, duration * 0.7)
	tween.start()
	tween.connect("tween_all_completed", piece, "queue_free")
