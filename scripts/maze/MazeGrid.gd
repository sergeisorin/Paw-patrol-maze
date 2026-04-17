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

enum Cell { WALL, PATH, START, GOAL, COLLECTIBLE, DEAD_END_SURPRISE }

func setup(width: int, height: int, maze_data: Array, theme_wall: Color = WALL_COLOR, theme_path: Color = PATH_COLOR) -> void:
	grid_width = width
	grid_height = height
	cells = maze_data
	_wall_theme_color = theme_wall
	_path_theme_color = theme_path
	_build_visuals()

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

func _create_wall_tile(pos: Vector2) -> void:
	var sprite = Sprite.new()
	var img = Image.new()
	img.create(CELL_SIZE, CELL_SIZE, false, Image.FORMAT_RGBA8)
	img.lock()
	var base = _wall_theme_color
	for px in range(CELL_SIZE):
		for py in range(CELL_SIZE):
			var noise_val = sin(px * 0.8) * cos(py * 0.6) * 0.04
			var edge_fade = 1.0
			var edge_dist = min(min(px, CELL_SIZE - 1 - px), min(py, CELL_SIZE - 1 - py))
			if edge_dist < 4:
				edge_fade = 0.92 + 0.08 * (edge_dist / 4.0)
			var c = Color(
				clamp(base.r * edge_fade + noise_val, 0, 1),
				clamp(base.g * edge_fade + noise_val * 0.8, 0, 1),
				clamp(base.b * edge_fade + noise_val * 0.5, 0, 1)
			)
			img.set_pixel(px, py, c)
	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	sprite.texture = tex
	sprite.position = pos
	add_child(sprite)

func _create_path_tile(pos: Vector2) -> void:
	var sprite = Sprite.new()
	var img = Image.new()
	img.create(CELL_SIZE, CELL_SIZE, false, Image.FORMAT_RGBA8)
	img.lock()
	var base = _path_theme_color
	for px in range(CELL_SIZE):
		for py in range(CELL_SIZE):
			var variation = sin(px * 0.3 + py * 0.2) * 0.015
			var c = Color(
				clamp(base.r + variation, 0, 1),
				clamp(base.g + variation, 0, 1),
				clamp(base.b + variation * 0.5, 0, 1)
			)
			if px == 0 or py == 0:
				c = c.darkened(0.04)
			img.set_pixel(px, py, c)
	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	sprite.texture = tex
	sprite.position = pos
	add_child(sprite)

func _create_goal_marker(pos: Vector2) -> void:
	_goal_sprite = Sprite.new()
	var size = CELL_SIZE
	var img = Image.new()
	img.create(size, size, false, Image.FORMAT_RGBA8)
	img.lock()
	var cx = size / 2.0
	var cy = size / 2.0
	var outer_r = size * 0.42
	var inner_r = outer_r * 0.42
	var points = 5

	# Precompute star polygon vertices
	var star_verts = []
	for i in range(points * 2):
		var angle = (float(i) / float(points * 2)) * TAU - PI / 2
		var r = outer_r if i % 2 == 0 else inner_r
		star_verts.append(Vector2(cx + cos(angle) * r, cy + sin(angle) * r))

	for px in range(size):
		for py in range(size):
			var p = Vector2(px, py)
			var dist_center = p.distance_to(Vector2(cx, cy))

			# Outer glow
			if dist_center < outer_r * 1.4 and dist_center > outer_r * 0.9:
				var glow_alpha = (1.0 - (dist_center - outer_r * 0.9) / (outer_r * 0.5)) * 0.25
				if glow_alpha > 0.01:
					img.set_pixel(px, py, Color(1.0, 0.95, 0.4, clamp(glow_alpha, 0, 0.3)))

			# Star fill using winding number test
			if _point_in_star(p, star_verts):
				var grad = dist_center / outer_r
				var brightness = 1.0 - grad * 0.2
				img.set_pixel(px, py, Color(
					clamp(1.0 * brightness, 0, 1),
					clamp(0.82 * brightness, 0, 1),
					clamp(0.1, 0, 1)
				))

			# Bright center highlight
			if dist_center < inner_r * 0.7:
				var hl = 1.0 - dist_center / (inner_r * 0.7)
				var base = img.get_pixel(px, py)
				if base.a > 0:
					img.set_pixel(px, py, base.linear_interpolate(Color.white, hl * 0.4))

	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	_goal_sprite.texture = tex
	_goal_sprite.position = pos
	_goal_sprite.z_index = 5
	add_child(_goal_sprite)
	_pulse_goal()

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
	tween.interpolate_property(_goal_sprite, "scale", Vector2(0.9, 0.9), Vector2(1.15, 1.15), 0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(_goal_sprite, "scale", Vector2(1.15, 1.15), Vector2(0.9, 0.9), 0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.8)
	tween.repeat = true
	tween.start()

func _create_collectible(pos: Vector2, grid_pos: Vector2) -> void:
	var sprite = Sprite.new()
	var size = 64
	var img = Image.new()
	img.create(size, size, false, Image.FORMAT_RGBA8)
	img.lock()
	var cx = size / 2.0
	var cy = size / 2.0
	var outer_r = size * 0.4
	var inner_r = outer_r * 0.4
	var points = 5

	var star_verts = []
	for i in range(points * 2):
		var angle = (float(i) / float(points * 2)) * TAU - PI / 2
		var r = outer_r if i % 2 == 0 else inner_r
		star_verts.append(Vector2(cx + cos(angle) * r, cy + sin(angle) * r))

	for px in range(size):
		for py in range(size):
			var p = Vector2(px, py)
			var dist_center = p.distance_to(Vector2(cx, cy))

			if _point_in_star(p, star_verts):
				var grad = dist_center / outer_r
				var brightness = 1.0 - grad * 0.15
				img.set_pixel(px, py, Color(
					clamp(1.0 * brightness, 0, 1),
					clamp(0.88 * brightness, 0, 1),
					clamp(0.15, 0, 1)
				))
				if dist_center < inner_r * 0.6:
					var hl = 1.0 - dist_center / (inner_r * 0.6)
					var base = img.get_pixel(px, py)
					img.set_pixel(px, py, base.linear_interpolate(Color(1, 1, 0.8), hl * 0.5))

	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, 0)
	sprite.texture = tex
	sprite.position = pos
	sprite.z_index = 5
	add_child(sprite)

	# Gentle sparkle animation
	var sparkle_tween = Tween.new()
	sprite.add_child(sparkle_tween)
	sparkle_tween.interpolate_property(sprite, "scale", Vector2(0.95, 0.95), Vector2(1.1, 1.1), 0.6, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	sparkle_tween.interpolate_property(sprite, "scale", Vector2(1.1, 1.1), Vector2(0.95, 0.95), 0.6, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.6)
	sparkle_tween.repeat = true
	sparkle_tween.start()

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
			var tween = Tween.new()
			node.add_child(tween)
			tween.interpolate_property(node, "scale", Vector2.ONE, Vector2(1.5, 1.5), 0.15, Tween.TRANS_BACK, Tween.EASE_OUT)
			tween.interpolate_property(node, "modulate:a", 1.0, 0.0, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN, 0.15)
			tween.start()
			tween.connect("tween_all_completed", node, "queue_free")
		emit_signal("collectible_picked", "star")
		return true
	return false

func check_goal(grid_pos: Vector2) -> bool:
	if grid_pos == goal_cell:
		if _goal_sprite and is_instance_valid(_goal_sprite):
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
