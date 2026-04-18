extends Node2D

signal collectible_picked(type)
signal goal_reached

const CELL_SIZE: int = 128
const WALL_COLOR := Color(0.35, 0.55, 0.3)
const PATH_COLOR := Color(0.85, 0.82, 0.7)
const DEAD_END_SURPRISE_COLOR := Color(1.0, 0.95, 0.5)

var grid_width: int = 0
var grid_height: int = 0
var cells: Array = []
var start_cell: Vector2 = Vector2.ZERO
var goal_cell: Vector2 = Vector2.ZERO
var collectible_cells: Array = []
var _collected: Array = []
var _goal_sprite: Sprite = null
var _collectible_nodes: Dictionary = {}
var _wall_theme_color: Color = WALL_COLOR
var _path_theme_color: Color = PATH_COLOR
var _tile_style: String = "outdoor"

var _wall_tex: Texture = null
var _path_tex: Texture = null
var _goal_tex: Texture = null
var _bone_tex: Texture = null

enum Cell { WALL, PATH, START, GOAL, COLLECTIBLE, DEAD_END_SURPRISE }

func setup(width: int, height: int, maze_data: Array, theme_wall: Color = WALL_COLOR, theme_path: Color = PATH_COLOR, tile_style: String = "outdoor", goal_sprite_name: String = "goal_doghouse.png") -> void:
	grid_width = width
	grid_height = height
	cells = maze_data
	_wall_theme_color = theme_wall
	_path_theme_color = theme_path
	_tile_style = tile_style
	_load_textures(goal_sprite_name)
	_build_visuals()
	_build_filler(5)

func _load_textures(goal_sprite_name: String = "goal_doghouse.png") -> void:
	var wall_suffix = "wall_tile.png" if _tile_style == "outdoor" else "wall_tile_indoor.png"
	var path_suffix = "path_tile.png" if _tile_style == "outdoor" else "path_tile_indoor.png"
	_wall_tex = load("res://assets/sprites/tiles/" + wall_suffix)
	_path_tex = load("res://assets/sprites/tiles/" + path_suffix)
	_goal_tex = load("res://assets/sprites/objects/" + goal_sprite_name)
	_bone_tex = load("res://assets/sprites/objects/collectible_bone.png")

func _build_visuals() -> void:
	for child in get_children():
		child.queue_free()

	for y in range(grid_height):
		for x in range(grid_width):
			var cell_type = cells[y][x]
			var pos = Vector2(x * CELL_SIZE + CELL_SIZE / 2, y * CELL_SIZE + CELL_SIZE / 2)

			if cell_type == Cell.WALL:
				_create_wall_tile(pos)
			else:
				_create_path_tile(pos)

			if cell_type == Cell.START:
				start_cell = Vector2(x, y)
			elif cell_type == Cell.GOAL:
				goal_cell = Vector2(x, y)
				_create_goal_marker(pos)
			elif cell_type == Cell.COLLECTIBLE:
				_create_collectible(pos, Vector2(x, y))
			elif cell_type == Cell.DEAD_END_SURPRISE:
				_create_dead_end_surprise(pos, Vector2(x, y))

func _build_filler(extra_cells: int) -> void:
	for y in range(-extra_cells, grid_height + extra_cells):
		for x in range(-extra_cells, grid_width + extra_cells):
			if x >= 0 and x < grid_width and y >= 0 and y < grid_height:
				continue
			var pos = Vector2(x * CELL_SIZE + CELL_SIZE / 2, y * CELL_SIZE + CELL_SIZE / 2)
			var sprite = Sprite.new()
			if _wall_tex:
				sprite.texture = _wall_tex
				sprite.modulate = _wall_theme_color.lightened(0.4).darkened(0.1)
			else:
				var img = Image.new()
				img.create(CELL_SIZE, CELL_SIZE, false, Image.FORMAT_RGBA8)
				img.fill(_wall_theme_color.darkened(0.1))
				var tex = ImageTexture.new()
				tex.create_from_image(img, 0)
				sprite.texture = tex
			sprite.position = pos
			sprite.z_index = -1
			add_child(sprite)

func _create_wall_tile(pos: Vector2) -> void:
	var sprite = Sprite.new()
	if _wall_tex:
		sprite.texture = _wall_tex
		sprite.modulate = _wall_theme_color.lightened(0.4)
	else:
		var img = Image.new()
		img.create(CELL_SIZE, CELL_SIZE, false, Image.FORMAT_RGBA8)
		img.fill(_wall_theme_color)
		var tex = ImageTexture.new()
		tex.create_from_image(img, 0)
		sprite.texture = tex
	sprite.position = pos
	add_child(sprite)

func _create_path_tile(pos: Vector2) -> void:
	var sprite = Sprite.new()
	if _path_tex:
		sprite.texture = _path_tex
		sprite.modulate = _path_theme_color.lightened(0.2)
	else:
		var img = Image.new()
		img.create(CELL_SIZE, CELL_SIZE, false, Image.FORMAT_RGBA8)
		img.fill(_path_theme_color)
		var tex = ImageTexture.new()
		tex.create_from_image(img, 0)
		sprite.texture = tex
	sprite.position = pos
	add_child(sprite)

func _create_goal_marker(pos: Vector2) -> void:
	var glow = _create_goal_glow()
	glow.position = pos
	glow.z_index = 4
	add_child(glow)
	_pulse_glow(glow)

	_goal_sprite = Sprite.new()
	if _goal_tex:
		_goal_sprite.texture = _goal_tex
	else:
		var size = CELL_SIZE
		var img = Image.new()
		img.create(size, size, false, Image.FORMAT_RGBA8)
		img.fill(Color(1.0, 0.82, 0.1))
		var tex = ImageTexture.new()
		tex.create_from_image(img, 0)
		_goal_sprite.texture = tex
	_goal_sprite.position = pos
	_goal_sprite.scale = Vector2(1.2, 1.2)
	_goal_sprite.z_index = 5
	add_child(_goal_sprite)
	_pulse_goal()

func _create_goal_glow() -> Sprite:
	var glow_size = 160
	var img = Image.new()
	img.create(glow_size, glow_size, false, Image.FORMAT_RGBA8)
	img.lock()
	var center = Vector2(glow_size / 2.0, glow_size / 2.0)
	var radius = glow_size / 2.0
	for px in range(glow_size):
		for py in range(glow_size):
			var dist = Vector2(px, py).distance_to(center)
			if dist < radius:
				var alpha = (1.0 - dist / radius) * 0.45
				img.set_pixel(px, py, Color(1.0, 0.92, 0.2, alpha))
	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	var sprite = Sprite.new()
	sprite.texture = tex
	return sprite

func _pulse_glow(glow: Sprite) -> void:
	var tween = Tween.new()
	glow.add_child(tween)
	tween.interpolate_property(glow, "scale", Vector2(0.9, 0.9), Vector2(1.3, 1.3), 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(glow, "scale", Vector2(1.3, 1.3), Vector2(0.9, 0.9), 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 1.0)
	tween.interpolate_property(glow, "modulate:a", 0.6, 1.0, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(glow, "modulate:a", 1.0, 0.6, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 1.0)
	tween.repeat = true
	tween.start()

func _point_in_star(point: Vector2, verts: Array) -> bool:
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

func _pulse_goal() -> void:
	if not _goal_sprite:
		return
	var tween = Tween.new()
	_goal_sprite.add_child(tween)
	tween.interpolate_property(_goal_sprite, "scale", Vector2(1.1, 1.1), Vector2(1.35, 1.35), 0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(_goal_sprite, "scale", Vector2(1.35, 1.35), Vector2(1.1, 1.1), 0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.8)
	tween.repeat = true
	tween.start()

func _create_collectible(pos: Vector2, grid_pos: Vector2) -> void:
	var sprite = Sprite.new()
	if _bone_tex:
		sprite.texture = _bone_tex
	else:
		var size = 64
		var img = Image.new()
		img.create(size, size, false, Image.FORMAT_RGBA8)
		img.fill(Color(1.0, 0.88, 0.15))
		var tex = ImageTexture.new()
		tex.create_from_image(img, 0)
		sprite.texture = tex
	sprite.position = pos
	sprite.z_index = 5
	add_child(sprite)

	var float_tween = Tween.new()
	sprite.add_child(float_tween)
	var base_scale = sprite.scale
	var float_up = pos + Vector2(0, -6)
	var float_down = pos + Vector2(0, 6)
	float_tween.interpolate_property(sprite, "position", float_down, float_up, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	float_tween.interpolate_property(sprite, "position", float_up, float_down, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.7)
	float_tween.interpolate_property(sprite, "scale", base_scale * 0.95, base_scale * 1.08, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	float_tween.interpolate_property(sprite, "scale", base_scale * 1.08, base_scale * 0.95, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.7)
	float_tween.repeat = true
	float_tween.start()

	collectible_cells.append(grid_pos)
	_collectible_nodes[grid_pos] = sprite

func _create_dead_end_surprise(pos: Vector2, grid_pos: Vector2) -> void:
	_create_collectible(pos, grid_pos)

func cell_to_world(grid_pos: Vector2) -> Vector2:
	return Vector2(grid_pos.x * CELL_SIZE + CELL_SIZE / 2, grid_pos.y * CELL_SIZE + CELL_SIZE / 2)

func world_to_cell(world_pos: Vector2) -> Vector2:
	return Vector2(int(world_pos.x / CELL_SIZE), int(world_pos.y / CELL_SIZE))

func is_walkable(grid_pos: Vector2) -> bool:
	if grid_pos.x < 0 or grid_pos.x >= grid_width:
		return false
	if grid_pos.y < 0 or grid_pos.y >= grid_height:
		return false
	return cells[int(grid_pos.y)][int(grid_pos.x)] != Cell.WALL

func try_collect(grid_pos: Vector2) -> bool:
	if grid_pos in collectible_cells and not grid_pos in _collected:
		_collected.append(grid_pos)
		if grid_pos in _collectible_nodes:
			var node = _collectible_nodes[grid_pos]
			_spawn_pickup_burst(node.position)
			var tween = Tween.new()
			node.add_child(tween)
			var base_scale = node.scale
			tween.interpolate_property(node, "scale", base_scale, base_scale * 1.5, 0.15, Tween.TRANS_BACK, Tween.EASE_OUT)
			tween.interpolate_property(node, "modulate:a", 1.0, 0.0, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN, 0.15)
			tween.start()
			tween.connect("tween_all_completed", node, "queue_free")
		emit_signal("collectible_picked", "bone")
		return true
	return false

func _spawn_pickup_burst(pos: Vector2) -> void:
	var burst_colors = [Color.yellow, Color.gold, Color(1.0, 0.6, 0.2), Color.white]
	for i in range(8):
		var particle = Sprite.new()
		var p_size = 12
		var img = Image.new()
		img.create(p_size, p_size, false, Image.FORMAT_RGBA8)
		img.lock()
		var center = Vector2(p_size / 2.0, p_size / 2.0)
		var c = burst_colors[randi() % burst_colors.size()]
		for px in range(p_size):
			for py in range(p_size):
				if Vector2(px, py).distance_to(center) < p_size * 0.4:
					img.set_pixel(px, py, c)
		img.unlock()
		var tex = ImageTexture.new()
		tex.create_from_image(img, 0)
		particle.texture = tex
		particle.position = pos
		particle.z_index = 8
		add_child(particle)

		var angle = (float(i) / 8.0) * TAU
		var target_pos = pos + Vector2(cos(angle), sin(angle)) * rand_range(30, 60)
		var burst_tween = Tween.new()
		particle.add_child(burst_tween)
		burst_tween.interpolate_property(particle, "position", pos, target_pos, 0.35, Tween.TRANS_QUAD, Tween.EASE_OUT)
		burst_tween.interpolate_property(particle, "modulate:a", 1.0, 0.0, 0.35, Tween.TRANS_LINEAR)
		burst_tween.interpolate_property(particle, "scale", Vector2.ONE, Vector2(0.2, 0.2), 0.35, Tween.TRANS_QUAD, Tween.EASE_IN)
		burst_tween.start()
		burst_tween.connect("tween_all_completed", particle, "queue_free")

func check_goal(grid_pos: Vector2) -> bool:
	if grid_pos == goal_cell:
		if _goal_sprite and is_instance_valid(_goal_sprite):
			_goal_sprite.visible = false
			_goal_sprite.queue_free()
			_goal_sprite = null
		emit_signal("goal_reached")
		return true
	return false

func get_collected_count() -> int:
	return _collected.size()

func get_total_collectibles() -> int:
	return collectible_cells.size()

func find_path_to_goal(from_cell: Vector2) -> Array:
	var queue = [from_cell]
	var visited = {from_cell: null}
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]

	while queue.size() > 0:
		var current = queue.pop_front()
		if current == goal_cell:
			var path = []
			var step = current
			while step != null:
				path.push_front(step)
				step = visited[step]
			return path

		for dir in directions:
			var neighbor = current + dir
			if is_walkable(neighbor) and not visited.has(neighbor):
				visited[neighbor] = current
				queue.append(neighbor)

	return []

func get_hint_direction(from_cell: Vector2) -> Vector2:
	var path = find_path_to_goal(from_cell)
	if path.size() >= 2:
		return path[1] - path[0]
	return Vector2.ZERO
