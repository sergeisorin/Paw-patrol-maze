extends Node

signal hint_triggered(target, hint_level)

var hint_delay_soft: float = 5.0
var hint_delay_strong: float = 10.0

var _active_targets: Array = []
var _timers: Dictionary = {}
var _hint_levels: Dictionary = {}

func _ready() -> void:
	pass

func register_target(target: Node) -> void:
	if target in _active_targets:
		return
	_active_targets.append(target)
	_hint_levels[target.get_instance_id()] = 0
	_start_hint_timer(target)

func unregister_target(target: Node) -> void:
	_active_targets.erase(target)
	var id = target.get_instance_id()
	if id in _timers:
		var timer = _timers[id]
		if is_instance_valid(timer):
			timer.queue_free()
		_timers.erase(id)
	_hint_levels.erase(id)

func clear_all() -> void:
	for target in _active_targets.duplicate():
		unregister_target(target)
	_active_targets.clear()
	_timers.clear()
	_hint_levels.clear()

func reset_timer(target: Node) -> void:
	var id = target.get_instance_id()
	_hint_levels[id] = 0
	if id in _timers and is_instance_valid(_timers[id]):
		_timers[id].queue_free()
		_timers.erase(id)
	_start_hint_timer(target)

func _start_hint_timer(target: Node) -> void:
	var id = target.get_instance_id()
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = hint_delay_soft
	add_child(timer)
	timer.connect("timeout", self, "_on_hint_timeout", [target])
	timer.start()
	_timers[id] = timer

func _on_hint_timeout(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var id = target.get_instance_id()
	var level = _hint_levels.get(id, 0)
	level += 1
	_hint_levels[id] = level

	emit_signal("hint_triggered", target, level)

	if target.has_method("show_hint"):
		target.show_hint(level)

	if level == 1:
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = hint_delay_strong - hint_delay_soft
		add_child(timer)
		timer.connect("timeout", self, "_on_hint_timeout", [target])
		timer.start()
		_timers[id] = timer
