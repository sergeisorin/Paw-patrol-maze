extends Node2D

signal moved(grid_pos)

var grid_pos: Vector2 = Vector2.ZERO
var _maze: Node = null
var _tween: Tween = null
var _is_moving: bool = false
var _move_speed: float = 0.15
var _sprite: Sprite = null
var _pup_color: Color = Color(0.2, 0.3, 0.8)
var _bounce_tween: Tween = null
var _hint_arrow: Sprite = null
var _hint_tween: Tween = null
var _hint_glow: Sprite = null

func setup(maze: Node, start_pos: Vector2, pup_color: Color) -> void:
	_maze = maze
	grid_pos = start_pos
	_pup_color = pup_color
	position = _maze.cell_to_world(grid_pos)
	_create_sprite()

func _ready() -> void:
	_tween = Tween.new()
	add_child(_tween)
	_bounce_tween = Tween.new()
	add_child(_bounce_tween)
	z_index = 10

func _create_sprite() -> void:
	if _sprite:
		_sprite.queue_free()
	_sprite = Sprite.new()
	var size = 96
	var img = Image.new()
	img.create(size, size, false, Image.FORMAT_RGBA8)
	img.lock()

	var cx = size / 2.0
	var cy = size / 2.0
	var body_r = 30.0
	var head_r = 24.0
	var body_c = Vector2(cx, cy + 6)
	var head_c = Vector2(cx, cy - 10)
	var ear_l = Vector2(cx - 16, cy - 28)
	var ear_r = Vector2(cx + 16, cy - 28)
	var ear_r_px = 10.0
	var collar_color = _pup_color.darkened(0.3)
	var belly_color = _pup_color.lightened(0.35)
	var nose_color = Color(0.2, 0.15, 0.15)
	var cheek_color = Color(1.0, 0.7, 0.65, 0.25)

	for px in range(size):
		for py in range(size):
			var p = Vector2(px, py)

			# Ears (drawn behind head)
			var dl = p.distance_to(ear_l)
			var dr = p.distance_to(ear_r)
			if dl < ear_r_px:
				var shade = 1.0 - dl / ear_r_px * 0.15
				img.set_pixel(px, py, _pup_color.darkened(0.1 * (1.0 - shade)))
			if dr < ear_r_px:
				var shade = 1.0 - dr / ear_r_px * 0.15
				img.set_pixel(px, py, _pup_color.darkened(0.1 * (1.0 - shade)))

			# Body
			var db = p.distance_to(body_c)
			if db < body_r:
				var grad = db / body_r
				img.set_pixel(px, py, _pup_color.lightened(0.05 * (1.0 - grad)))

			# Belly highlight
			var belly_c = Vector2(cx, cy + 12)
			var d_belly = p.distance_to(belly_c)
			if d_belly < 14:
				var alpha = (1.0 - d_belly / 14.0) * 0.5
				var base = img.get_pixel(px, py)
				if base.a > 0:
					img.set_pixel(px, py, base.linear_interpolate(belly_color, alpha))

			# Collar band
			var collar_cy = cy + 0
			if db < body_r and abs(py - collar_cy) < 4:
				img.set_pixel(px, py, collar_color)

			# Collar tag (small circle)
			var tag_c = Vector2(cx, collar_cy + 2)
			if p.distance_to(tag_c) < 5:
				img.set_pixel(px, py, Color(1.0, 0.85, 0.15))

			# Head (overlaps ears)
			var dh = p.distance_to(head_c)
			if dh < head_r:
				var grad = dh / head_r
				img.set_pixel(px, py, _pup_color.lightened(0.12 * (1.0 - grad)))

			# Muzzle
			var muzzle_c = Vector2(cx, cy - 4)
			var dm = p.distance_to(muzzle_c)
			if dm < 10:
				var base = img.get_pixel(px, py)
				if base.a > 0:
					img.set_pixel(px, py, base.linear_interpolate(belly_color, 0.6 * (1.0 - dm / 10.0)))

	# Eyes (white sclera + colored iris + black pupil)
	var eye_l = Vector2(cx - 8, cy - 14)
	var eye_r2 = Vector2(cx + 8, cy - 14)
	for eye_pos in [eye_l, eye_r2]:
		for px in range(int(eye_pos.x) - 6, int(eye_pos.x) + 7):
			for py in range(int(eye_pos.y) - 6, int(eye_pos.y) + 7):
				if px < 0 or px >= size or py < 0 or py >= size:
					continue
				var d = Vector2(px, py).distance_to(eye_pos)
				if d < 5:
					img.set_pixel(px, py, Color.white)
				if d < 3:
					img.set_pixel(px, py, _pup_color.darkened(0.5))
				if d < 1.8:
					img.set_pixel(px, py, Color.black)

	# Nose
	var nose_c = Vector2(cx, cy - 4)
	for px in range(int(nose_c.x) - 4, int(nose_c.x) + 5):
		for py in range(int(nose_c.y) - 3, int(nose_c.y) + 3):
			if px < 0 or px >= size or py < 0 or py >= size:
				continue
			var d = Vector2(px, py).distance_to(nose_c)
			if d < 3.5:
				img.set_pixel(px, py, nose_color)

	# Smile (arc below nose)
	for angle_deg in range(-50, 51):
		var rad = deg2rad(float(angle_deg))
		var sx = cx + cos(rad) * 7
		var sy = cy - 0 + sin(rad) * 4 + 3
		var ipx = int(sx)
		var ipy = int(sy)
		if ipx >= 0 and ipx < size and ipy >= 0 and ipy < size:
			if angle_deg > -50 and angle_deg < 50:
				img.set_pixel(ipx, ipy, Color(0.35, 0.2, 0.2))

	# Cheek blush
	for cheek_pos in [Vector2(cx - 14, cy - 6), Vector2(cx + 14, cy - 6)]:
		for px in range(int(cheek_pos.x) - 5, int(cheek_pos.x) + 6):
			for py in range(int(cheek_pos.y) - 3, int(cheek_pos.y) + 4):
				if px < 0 or px >= size or py < 0 or py >= size:
					continue
				var d = Vector2(px, py).distance_to(cheek_pos)
				if d < 4:
					var base = img.get_pixel(px, py)
					if base.a > 0:
						img.set_pixel(px, py, base.linear_interpolate(cheek_color, 0.35 * (1.0 - d / 4.0)))

	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	_sprite.texture = tex
	add_child(_sprite)

func _process(_delta: float) -> void:
	if _is_moving or not _maze:
		return

	var dir = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		dir = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		dir = Vector2.RIGHT
	elif Input.is_action_pressed("move_up"):
		dir = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		dir = Vector2.DOWN

	if dir != Vector2.ZERO:
		hide_hint()
		_try_move(dir)

func _try_move(dir: Vector2) -> void:
	var target = grid_pos + dir
	if _maze.is_walkable(target):
		_is_moving = true
		grid_pos = target

		emit_signal("moved", grid_pos)
		_maze.try_collect(grid_pos)

		var world_target = _maze.cell_to_world(target)
		_tween.stop_all()
		_tween.interpolate_property(self, "position", position, world_target, _move_speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
		_tween.start()
		_tween.connect("tween_all_completed", self, "_on_move_tween_done", [], CONNECT_ONESHOT)
	else:
		AudioManager.play_sfx("tap")
		_bump_animation(dir)

func _on_move_tween_done() -> void:
	_is_moving = false
	_bounce()
	_maze.check_goal(grid_pos)

func _bounce() -> void:
	if _sprite:
		_bounce_tween.stop_all()
		_bounce_tween.interpolate_property(_sprite, "scale", Vector2(1.0, 0.85), Vector2(1.0, 1.0), 0.12, Tween.TRANS_BACK, Tween.EASE_OUT)
		_bounce_tween.start()

func _bump_animation(dir: Vector2) -> void:
	var bump_offset = dir * 8
	_tween.stop_all()
	_tween.interpolate_property(self, "position", position, position + bump_offset, 0.06, Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.interpolate_property(self, "position", position + bump_offset, position, 0.06, Tween.TRANS_QUAD, Tween.EASE_IN, 0.06)
	_tween.start()

func show_hint(level: int) -> void:
	if not _maze:
		return
	var dir = _maze.get_hint_direction(grid_pos)
	if dir == Vector2.ZERO:
		return

	hide_hint()
	AudioManager.play_sfx("hint")

	_hint_arrow = _create_hint_arrow(level)
	_hint_arrow.rotation = atan2(dir.y, dir.x)
	_hint_arrow.position = dir * 48
	_hint_arrow.z_index = 15
	add_child(_hint_arrow)

	_hint_tween = Tween.new()
	add_child(_hint_tween)

	var bob_from = _hint_arrow.position
	var bob_to = _hint_arrow.position + dir * 12
	_hint_tween.interpolate_property(_hint_arrow, "position", bob_from, bob_to, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_hint_tween.interpolate_property(_hint_arrow, "position", bob_to, bob_from, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.5)

	var base_scale = Vector2(1.0, 1.0) if level == 1 else Vector2(1.4, 1.4)
	var pulse_scale = base_scale * 1.15
	_hint_tween.interpolate_property(_hint_arrow, "scale", base_scale, pulse_scale, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_hint_tween.interpolate_property(_hint_arrow, "scale", pulse_scale, base_scale, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	_hint_tween.repeat = true
	_hint_tween.start()

	if level >= 2:
		_show_path_glow()

func _create_hint_arrow(level: int) -> Sprite:
	var sprite = Sprite.new()
	var size = 48 if level == 1 else 64
	var img = Image.new()
	img.create(size, size, false, Image.FORMAT_RGBA8)
	img.lock()
	var cx = size / 2.0
	var cy = size / 2.0
	var arrow_color = Color(1.0, 0.95, 0.3, 0.9) if level == 1 else Color(1.0, 0.7, 0.1, 1.0)
	var glow_color = Color(1.0, 1.0, 0.6, 0.3)

	for px in range(size):
		for py in range(size):
			var x = px - cx
			var y = py - cy
			var half = size * 0.45

			var in_arrow = false
			if x > 0 and abs(y) < half * (1.0 - x / half):
				in_arrow = true
			if x <= 0 and abs(y) < half * 0.3 and x > -half * 0.5:
				in_arrow = true

			if in_arrow:
				img.set_pixel(px, py, arrow_color)
			elif level >= 2:
				var dx = x - half * 0.2
				var dy = y
				var dist = sqrt(dx * dx + dy * dy)
				if dist < half * 0.8:
					var alpha = clamp(0.3 - dist / (half * 3.0), 0.0, 0.3)
					if alpha > 0.02:
						img.set_pixel(px, py, Color(glow_color.r, glow_color.g, glow_color.b, alpha))
	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	sprite.texture = tex
	return sprite

func _show_path_glow() -> void:
	if not _maze:
		return
	var path = _maze.find_path_to_goal(grid_pos)
	if path.size() < 2:
		return

	var steps = min(path.size(), 4)
	for i in range(1, steps):
		var cell = path[i]
		var world_pos = _maze.cell_to_world(cell) - position
		var glow = Sprite.new()
		var glow_size = 64
		var glow_img = Image.new()
		glow_img.create(glow_size, glow_size, false, Image.FORMAT_RGBA8)
		glow_img.lock()
		var gc = Vector2(glow_size / 2, glow_size / 2)
		var fade = 1.0 - float(i) / float(steps)
		for px in range(glow_size):
			for py in range(glow_size):
				var dist = Vector2(px, py).distance_to(gc)
				if dist < glow_size * 0.4:
					var alpha = (1.0 - dist / (glow_size * 0.4)) * 0.35 * fade
					glow_img.set_pixel(px, py, Color(1.0, 0.95, 0.4, alpha))
		glow_img.unlock()
		var glow_tex = ImageTexture.new()
		glow_tex.create_from_image(glow_img, 0)
		glow.texture = glow_tex
		glow.position = world_pos
		glow.z_index = 3
		glow.name = "HintGlow"
		add_child(glow)

func hide_hint() -> void:
	if _hint_arrow and is_instance_valid(_hint_arrow):
		_hint_arrow.queue_free()
		_hint_arrow = null
	if _hint_tween and is_instance_valid(_hint_tween):
		_hint_tween.queue_free()
		_hint_tween = null
	for child in get_children():
		if child.name == "HintGlow":
			child.queue_free()
