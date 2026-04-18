extends Node2D

signal moved(grid_pos)

var grid_pos: Vector2 = Vector2.ZERO
var _maze: Node = null
var _tween: Tween = null
var _is_moving: bool = false
var _disabled: bool = false
var _move_speed: float = 0.25
var _sprite: Sprite = null
var _pup_color: Color = Color(0.2, 0.3, 0.8)
var _pup_id: String = "chase"
var _bounce_tween: Tween = null
var _hint_arrow: Sprite = null
var _hint_tween: Tween = null
var _hint_glow: Sprite = null
var _idle_tween: Tween = null
var _trail_timer: float = 0.0

func setup(maze: Node, start_pos: Vector2, pup_color: Color, pup_id: String = "chase") -> void:
	_maze = maze
	grid_pos = start_pos
	_pup_color = pup_color
	_pup_id = pup_id
	position = _maze.cell_to_world(grid_pos)
	_create_sprite()
	_start_idle_breathing()

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

	var tex_path = "res://assets/sprites/pups/" + _pup_id + ".png"
	var tex = load(tex_path)
	if tex:
		_sprite.texture = tex
		var tex_size = tex.get_size()
		var target_size = 100.0
		_sprite.scale = Vector2(target_size / tex_size.x, target_size / tex_size.y)
	else:
		var img = Image.new()
		img.create(96, 96, false, Image.FORMAT_RGBA8)
		img.lock()
		var center = Vector2(48, 48)
		for px in range(96):
			for py in range(96):
				if Vector2(px, py).distance_to(center) < 36:
					img.set_pixel(px, py, _pup_color)
		img.unlock()
		var fallback_tex = ImageTexture.new()
		fallback_tex.create_from_image(img, 0)
		_sprite.texture = fallback_tex

	add_child(_sprite)

func disable() -> void:
	if _disabled:
		return
	print("[MazePlayer] disable() called")
	_disabled = true
	_is_moving = true
	set_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	if _tween:
		_tween.stop_all()
	if _bounce_tween:
		_bounce_tween.stop_all()
	if _idle_tween:
		_idle_tween.stop_all()

func _process(_delta: float) -> void:
	if _disabled or _is_moving or not _maze:
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
		_rotate_to(dir)
		_try_move(dir)

func _rotate_to(dir: Vector2) -> void:
	if not _sprite:
		return
	var target_angle = 0.0
	if dir == Vector2.UP:
		target_angle = 180.0
	elif dir == Vector2.DOWN:
		target_angle = 0.0
	elif dir == Vector2.LEFT:
		target_angle = 90.0
	elif dir == Vector2.RIGHT:
		target_angle = -90.0
	_sprite.rotation_degrees = target_angle

func _try_move(dir: Vector2) -> void:
	var target = grid_pos + dir
	if not _maze.is_walkable(target):
		AudioManager.play_sfx("wall_bump")
		_bump_animation(dir)
		return
	_is_moving = true
	grid_pos = target
	emit_signal("moved", grid_pos)
	_maze.try_collect(grid_pos)
	var world_target = _maze.cell_to_world(target)
	_tween.stop_all()
	_tween.interpolate_property(self, "position", position, world_target, _move_speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()
	_tween.connect("tween_all_completed", self, "_on_move_tween_done", [], CONNECT_ONESHOT)

func _on_bump_done() -> void:
	_is_moving = false
	position = _maze.cell_to_world(grid_pos)

func _on_move_tween_done() -> void:
	_is_moving = false
	print("[MazePlayer] move done at grid_pos=", grid_pos, " goal=", _maze.goal_cell)
	var on_goal = _maze.check_goal(grid_pos)
	if on_goal:
		print("[MazePlayer] GOAL REACHED - disabling")
		disable()

func _bounce() -> void:
	if _sprite:
		var base = _sprite.scale
		var squash = Vector2(base.x * 1.1, base.y * 0.9)
		_bounce_tween.stop_all()
		_bounce_tween.interpolate_property(_sprite, "scale", squash, base, 0.12, Tween.TRANS_BACK, Tween.EASE_OUT)
		_bounce_tween.start()

func _bump_animation(dir: Vector2) -> void:
	_is_moving = true
	var home_pos = _maze.cell_to_world(grid_pos)
	position = home_pos
	var bump_target = home_pos + dir * 8
	_tween.stop_all()
	_tween.interpolate_property(self, "position", home_pos, bump_target, 0.06, Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.interpolate_property(self, "position", bump_target, home_pos, 0.06, Tween.TRANS_QUAD, Tween.EASE_IN, 0.06)
	_tween.start()
	_tween.connect("tween_all_completed", self, "_on_bump_done", [], CONNECT_ONESHOT)

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
		pass

func _create_hint_arrow(_level: int) -> Sprite:
	var sprite = Sprite.new()
	var tex = load("res://assets/sprites/objects/hint_arrow.png")
	if tex:
		sprite.texture = tex
		if _level == 1:
			sprite.scale = Vector2(0.75, 0.75)
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
		_hint_arrow.free()
		_hint_arrow = null
	if _hint_tween and is_instance_valid(_hint_tween):
		_hint_tween.free()
		_hint_tween = null
	var to_remove = []
	for child in get_children():
		if child.name == "HintGlow":
			to_remove.append(child)
	for c in to_remove:
		c.free()

func _start_idle_breathing() -> void:
	if not _sprite:
		return
	_idle_tween = Tween.new()
	add_child(_idle_tween)
	var base_scale = _sprite.scale
	var breathe_in = base_scale * 1.04
	var breathe_out = base_scale * 0.97
	_idle_tween.interpolate_property(_sprite, "scale", breathe_out, breathe_in, 0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_idle_tween.interpolate_property(_sprite, "scale", breathe_in, breathe_out, 0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.8)
	_idle_tween.repeat = true
	_idle_tween.start()

func _spawn_trail() -> void:
	var trail = Sprite.new()
	var trail_size = 20
	var img = Image.new()
	img.create(trail_size, trail_size, false, Image.FORMAT_RGBA8)
	img.lock()
	var center = Vector2(trail_size / 2.0, trail_size / 2.0)
	for px in range(trail_size):
		for py in range(trail_size):
			var dist = Vector2(px, py).distance_to(center)
			if dist < trail_size * 0.4:
				var alpha = (1.0 - dist / (trail_size * 0.4)) * 0.5
				img.set_pixel(px, py, Color(_pup_color.r, _pup_color.g, _pup_color.b, alpha))
	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	trail.texture = tex
	trail.global_position = global_position
	trail.z_index = 1
	get_parent().add_child(trail)
	var trail_tween = Tween.new()
	trail.add_child(trail_tween)
	trail_tween.interpolate_property(trail, "modulate:a", 0.5, 0.0, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	trail_tween.interpolate_property(trail, "scale", Vector2.ONE, Vector2(0.3, 0.3), 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	trail_tween.start()
	trail_tween.connect("tween_all_completed", trail, "queue_free")

func play_victory_spin() -> void:
	if not _sprite:
		return
	var spin_tween = Tween.new()
	_sprite.add_child(spin_tween)
	spin_tween.interpolate_property(_sprite, "rotation_degrees", 0, 360, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	spin_tween.start()
