extends Reference
class_name MazeGenerator

const W := 0
const P := 1
const S := 2
const G := 3
const C := 4
const D := 5

static func maze_dimensions_for_level(level: int) -> Vector2:
	var L = clamp(level, 0, 26)
	var wf = lerp(9.0, 17.0, float(L) / 26.0)
	var hf = lerp(7.0, 15.0, float(L) / 26.0)
	var w = int(round(wf))
	var h = int(round(hf))
	if w % 2 == 0:
		w += 1
	if h % 2 == 0:
		h += 1
	w = int(clamp(w, 9, 17))
	h = int(clamp(h, 7, 15))
	return Vector2(w, h)


static func generate_for_mission(level: int) -> Array:
	var dim = maze_dimensions_for_level(level)
	var w = int(dim.x)
	var h = int(dim.y)
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(48107 + level * 65537)

	for attempt in range(24):
		rng.seed = hash(48107 + level * 65537 + attempt * 9973)
		var raw = _carve_perfect_maze(w, h, rng)
		var finished = _place_entities(raw, w, h, level, rng)
		if finished != null:
			return finished

	push_warning("MazeGenerator fallback for level %s" % level)
	var raw_fallback = _carve_perfect_maze(w, h, rng)
	var fb = _place_entities(raw_fallback, w, h, level, rng)
	if fb != null:
		return fb
	return _force_place_start_goal(raw_fallback, w, h)


static func _force_place_start_goal(maze: Array, width: int, height: int) -> Array:
	var pcs = []
	for y in height:
		for x in width:
			if maze[y][x] == P:
				pcs.append(Vector2(x, y))
	if pcs.empty():
		return maze
	var s = pcs[0]
	var g = pcs[pcs.size() - 1]
	if g == s and pcs.size() > 1:
		g = pcs[1]
	maze[int(s.y)][int(s.x)] = S
	maze[int(g.y)][int(g.x)] = G
	return maze


static func _carve_perfect_maze(width: int, height: int, rng: RandomNumberGenerator) -> Array:
	var maze = []
	for y in height:
		var row = []
		row.resize(width)
		for x in width:
			row[x] = W
		maze.append(row)

	var dirs = [Vector2(2, 0), Vector2(-2, 0), Vector2(0, 2), Vector2(0, -2)]
	var stack = []
	var start = Vector2(1, 1)
	maze[int(start.y)][int(start.x)] = P
	stack.append(start)

	while stack.size() > 0:
		var current = stack[-1]
		var neighbors = []
		for d in dirs:
			var nx = int(current.x + d.x)
			var ny = int(current.y + d.y)
			if nx <= 0 or nx >= width - 1 or ny <= 0 or ny >= height - 1:
				continue
			if maze[ny][nx] != W:
				continue
			neighbors.append(Vector2(nx, ny))
		if neighbors.empty():
			stack.pop_back()
			continue
		var next = neighbors[rng.randi() % neighbors.size()]
		var wall_x = int(current.x + int((next.x - current.x) / 2))
		var wall_y = int(current.y + int((next.y - current.y) / 2))
		maze[wall_y][wall_x] = P
		maze[int(next.y)][int(next.x)] = P
		stack.append(next)

	return maze


static func _sort_cells_by_x(cells: Array) -> void:
	var n = cells.size()
	for i in range(n):
		for j in range(i + 1, n):
			if cells[j].x < cells[i].x:
				var tmp = cells[i]
				cells[i] = cells[j]
				cells[j] = tmp


static func _shuffle_with_rng(arr: Array, rng: RandomNumberGenerator) -> void:
	for i in range(arr.size() - 1, 0, -1):
		var j = rng.randi() % (i + 1)
		var tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp


static func _place_entities(maze: Array, width: int, height: int, level: int, rng: RandomNumberGenerator):
	var path_cells = []
	for y in height:
		for x in width:
			if maze[y][x] == P:
				path_cells.append(Vector2(x, y))
	if path_cells.size() < 4:
		return null

	var start_pos = path_cells[0]
	var max_y = start_pos.y
	for c in path_cells:
		if c.y > max_y:
			max_y = c.y
	var bottom = []
	for c in path_cells:
		if c.y == max_y:
			bottom.append(c)
	_sort_cells_by_x(bottom)
	start_pos = bottom[bottom.size() / 2]

	var dist_map = {}
	var parents = {}
	var q = [start_pos]
	dist_map[start_pos] = 0
	var head = 0
	var dirs4 = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	while head < q.size():
		var cur = q[head]
		head += 1
		for d in dirs4:
			var n = cur + d
			if n.x < 0 or n.x >= width or n.y < 0 or n.y >= height:
				continue
			if maze[int(n.y)][int(n.x)] != P:
				continue
			if dist_map.has(n):
				continue
			dist_map[n] = dist_map[cur] + 1
			parents[n] = cur
			q.append(n)

	var goal_pos = start_pos
	var best_d = -1
	for c in path_cells:
		var di = dist_map.get(c, -1)
		if di > best_d:
			best_d = di
			goal_pos = c

	if goal_pos == start_pos:
		return null

	var path_set = {}
	var walker = goal_pos
	while true:
		path_set[walker] = true
		if walker == start_pos:
			break
		if not parents.has(walker):
			return null
		walker = parents[walker]

	var dead_ends_off_path = []
	var all_off_path = []
	for c in path_cells:
		if c == start_pos or c == goal_pos:
			continue
		if path_set.has(c):
			continue
		all_off_path.append(c)
		var pn = _path_neighbor_count(maze, width, height, c)
		if pn == 1:
			dead_ends_off_path.append(c)

	_shuffle_with_rng(dead_ends_off_path, rng)

	var surprise_budget = int(clamp(level / 5, 0, 4))
	# At least 2 bones on side branches; grows with mission (level == mission index).
	var collectible_target = int(clamp(2 + level / 2, 2, 10))
	var chosen_surprises = min(surprise_budget, dead_ends_off_path.size())

	var surprise_cells = []
	for i in chosen_surprises:
		surprise_cells.append(dead_ends_off_path[i])

	var surprise_set = {}
	for s in surprise_cells:
		surprise_set[s] = true

	var collect_pool = []
	for c in all_off_path:
		if surprise_set.has(c):
			continue
		collect_pool.append(c)
	_shuffle_with_rng(collect_pool, rng)

	var chosen_collect = min(collectible_target, collect_pool.size())
	var collectible_cells = []
	for i in chosen_collect:
		collectible_cells.append(collect_pool[i])

	for y in height:
		for x in width:
			var pos = Vector2(x, y)
			if maze[y][x] != P:
				continue
			if pos == start_pos:
				maze[y][x] = S
			elif pos == goal_pos:
				maze[y][x] = G
			elif pos in surprise_cells:
				maze[y][x] = D
			elif pos in collectible_cells:
				maze[y][x] = C
			else:
				maze[y][x] = P

	return maze


static func _path_neighbor_count(maze: Array, width: int, height: int, c: Vector2) -> int:
	var dirs4 = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	var ncount = 0
	for d in dirs4:
		var n = c + d
		if n.x < 0 or n.x >= width or n.y < 0 or n.y >= height:
			continue
		if maze[int(n.y)][int(n.x)] == P:
			ncount += 1
	return ncount
