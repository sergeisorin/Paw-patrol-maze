extends Node

signal mission_unlocked(mission_index)
signal badge_earned(badge_name)
signal game_completed

var _font_data_bold: DynamicFontData = null
var _font_data_regular: DynamicFontData = null

var current_mission: int = 0
var missions_completed: Array = []
var badges_earned: Array = []
var collectibles_total: int = 0

var pup_data: Dictionary = {
	"chase": {"name": "Гонщик", "color": Color(0.2, 0.3, 0.8)},
	"marshall": {"name": "Маршал", "color": Color(0.9, 0.2, 0.2)},
	"skye": {"name": "Скай", "color": Color(1.0, 0.5, 0.7)},
	"rubble": {"name": "Крепыш", "color": Color(0.8, 0.7, 0.2)},
	"zuma": {"name": "Зума", "color": Color(0.3, 0.7, 0.9)},
	"rocky": {"name": "Рокки", "color": Color(0.3, 0.7, 0.3)},
}

var mission_data: Array = [
	{
		"id": "m1_chase_balloon",
		"title": "Chase and the Lost Balloon",
		"pup": "chase",
		"zone": "town",
		"scene": "res://scenes/maze/Mission1_ChaseBalloon.tscn",
		"goal_text": "Найди шарик!",
		"badge": "Звезда Города",
	},
	{
		"id": "m2_marshall_hose",
		"title": "Marshall Brings the Water Hose",
		"pup": "marshall",
		"zone": "farm",
		"scene": "res://scenes/maze/Mission2_MarshallHose.tscn",
		"goal_text": "Найди шланг!",
		"badge": "Звезда Фермы",
	},
	{
		"id": "m3_skye_kitten",
		"title": "Skye and the Butterfly Garden",
		"pup": "skye",
		"zone": "garden",
		"scene": "res://scenes/maze/Mission3_SkyeKitten.tscn",
		"goal_text": "Найди котёнка!",
		"badge": "Звезда Сада",
	},
	{
		"id": "m4_zuma_boat",
		"title": "Zuma and the Dock Maze",
		"pup": "zuma",
		"zone": "beach",
		"scene": "res://scenes/maze/Mission4_ZumaBoat.tscn",
		"goal_text": "Найди кораблик!",
		"badge": "Звезда Моря",
	},
	{
		"id": "m5_rubble_tools",
		"title": "Rubble Fixes the Road",
		"pup": "rubble",
		"zone": "yard",
		"scene": "res://scenes/maze/Mission5_RubbleRoad.tscn",
		"goal_text": "Найди инструменты!",
		"badge": "Звезда Стройки",
	},
	{
		"id": "m6_rocky_cart",
		"title": "Rocky's Recycling Rescue",
		"pup": "rocky",
		"zone": "garden",
		"scene": "res://scenes/maze/Mission6_RockyCart.tscn",
		"goal_text": "Найди тележку!",
		"badge": "Звезда Переработки",
	},
	{
		"id": "m7_team_lookout",
		"title": "Team Maze to the Lookout",
		"pup": "chase",
		"zone": "hill",
		"scene": "res://scenes/maze/Mission7_TeamLookout.tscn",
		"goal_text": "Доберись до Базы!",
		"badge": "Чемпион Спасения",
	},
	{
		"id": "m8_marshall_campfire",
		"title": "Marshall and the Campfire",
		"pup": "marshall",
		"zone": "farm",
		"scene": "res://scenes/maze/Mission8_MarshallCampfire.tscn",
		"goal_text": "Потуши костёр!",
		"badge": "Звезда Пожарных",
	},
	{
		"id": "m9_skye_bird",
		"title": "Skye Finds the Lost Bird",
		"pup": "skye",
		"zone": "garden",
		"scene": "res://scenes/maze/Mission9_SkyeBird.tscn",
		"goal_text": "Найди домик птички!",
		"badge": "Звезда Неба",
	},
	{
		"id": "m10_zuma_lighthouse",
		"title": "Zuma and the Lighthouse",
		"pup": "zuma",
		"zone": "beach",
		"scene": "res://scenes/maze/Mission10_ZumaLighthouse.tscn",
		"goal_text": "Включи маяк!",
		"badge": "Звезда Маяка",
	},
	{
		"id": "m11_rubble_sandcastle",
		"title": "Rubble and the Sandcastle",
		"pup": "rubble",
		"zone": "yard",
		"scene": "res://scenes/maze/Mission11_RubbleSandcastle.tscn",
		"goal_text": "Построй замок!",
		"badge": "Звезда Замков",
	},
	{
		"id": "m12_rocky_wrench",
		"title": "Rocky Finds the Wrench",
		"pup": "rocky",
		"zone": "garden",
		"scene": "res://scenes/maze/Mission12_RockyWrench.tscn",
		"goal_text": "Найди ключ!",
		"badge": "Звезда Мастера",
	},
	{
		"id": "m13_chase_key",
		"title": "Chase and the Missing Key",
		"pup": "chase",
		"zone": "town",
		"scene": "res://scenes/maze/Mission13_ChaseKey.tscn",
		"goal_text": "Найди ключ!",
		"badge": "Звезда Следопыта",
	},
	{
		"id": "m14_marshall_barncat",
		"title": "Marshall and the Barn Cat",
		"pup": "marshall",
		"zone": "farm",
		"scene": "res://scenes/maze/Mission14_MarshallBarnCat.tscn",
		"goal_text": "Найди котёнка!",
		"badge": "Звезда Амбара",
	},
	{
		"id": "m15_skye_kite",
		"title": "Skye and the Kite",
		"pup": "skye",
		"zone": "garden",
		"scene": "res://scenes/maze/Mission15_SkyeKite.tscn",
		"goal_text": "Поймай змея!",
		"badge": "Звезда Ветра",
	},
	{
		"id": "m16_zuma_treasure",
		"title": "Zuma and the Treasure Chest",
		"pup": "zuma",
		"zone": "beach",
		"scene": "res://scenes/maze/Mission16_ZumaTreasure.tscn",
		"goal_text": "Найди сундук!",
		"badge": "Звезда Сокровищ",
	},
	{
		"id": "m17_rubble_bridge",
		"title": "Rubble Builds the Bridge",
		"pup": "rubble",
		"zone": "yard",
		"scene": "res://scenes/maze/Mission17_RubbleBridge.tscn",
		"goal_text": "Построй мост!",
		"badge": "Звезда Мостов",
	},
	{
		"id": "m18_rocky_windmill",
		"title": "Rocky and the Windmill",
		"pup": "rocky",
		"zone": "garden",
		"scene": "res://scenes/maze/Mission18_RockyWindmill.tscn",
		"goal_text": "Почини мельницу!",
		"badge": "Звезда Мельниц",
	},
	{
		"id": "m19_chase_firetruck",
		"title": "Chase and the Fire Truck",
		"pup": "chase",
		"zone": "town",
		"scene": "res://scenes/maze/Mission19_ChaseFiretruck.tscn",
		"goal_text": "Найди машину!",
		"badge": "Звезда Патруля",
	},
	{
		"id": "m20_marshall_cookies",
		"title": "Marshall and the Cookie Jar",
		"pup": "marshall",
		"zone": "farm",
		"scene": "res://scenes/maze/Mission20_MarshallCookies.tscn",
		"goal_text": "Найди печенье!",
		"badge": "Звезда Кухни",
	},
	{
		"id": "m21_skye_rainbow",
		"title": "Skye and the Rainbow",
		"pup": "skye",
		"zone": "garden",
		"scene": "res://scenes/maze/Mission21_SkyeRainbow.tscn",
		"goal_text": "Долети до радуги!",
		"badge": "Звезда Радуги",
	},
	{
		"id": "m22_zuma_whale",
		"title": "Zuma and the Whale",
		"pup": "zuma",
		"zone": "beach",
		"scene": "res://scenes/maze/Mission22_ZumaWhale.tscn",
		"goal_text": "Спаси китёнка!",
		"badge": "Звезда Океана",
	},
	{
		"id": "m23_rubble_train",
		"title": "Rubble and the Train",
		"pup": "rubble",
		"zone": "yard",
		"scene": "res://scenes/maze/Mission23_RubbleTrain.tscn",
		"goal_text": "Почини поезд!",
		"badge": "Звезда Рельсов",
	},
	{
		"id": "m24_rocky_telescope",
		"title": "Rocky and the Telescope",
		"pup": "rocky",
		"zone": "garden",
		"scene": "res://scenes/maze/Mission24_RockyTelescope.tscn",
		"goal_text": "Почини телескоп!",
		"badge": "Звезда Звёзд",
	},
	{
		"id": "m25_chase_trophy",
		"title": "Chase and the Trophy",
		"pup": "chase",
		"zone": "town",
		"scene": "res://scenes/maze/Mission25_ChaseTrophy.tscn",
		"goal_text": "Найди кубок!",
		"badge": "Звезда Чемпионов",
	},
	{
		"id": "m26_marshall_fireworks",
		"title": "Marshall and the Fireworks",
		"pup": "marshall",
		"zone": "farm",
		"scene": "res://scenes/maze/Mission26_MarshallFireworks.tscn",
		"goal_text": "Найди фейерверки!",
		"badge": "Звезда Праздника",
	},
	{
		"id": "m27_celebration",
		"title": "The Great Celebration",
		"pup": "chase",
		"zone": "hill",
		"scene": "res://scenes/maze/Mission27_Celebration.tscn",
		"goal_text": "Дойди до вечеринки!",
		"badge": "Супер Герой",
	},
]

func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS
	_font_data_bold = DynamicFontData.new()
	_font_data_bold.font_path = "res://assets/fonts/NotoSans-Bold.ttf"
	_font_data_regular = DynamicFontData.new()
	_font_data_regular.font_path = "res://assets/fonts/NotoSans-Regular.ttf"
	_schedule_cmdline_qa_mission()

func make_font(size: int, bold: bool = true) -> DynamicFont:
	var font = DynamicFont.new()
	font.font_data = _font_data_bold if bold else _font_data_regular
	font.size = size
	return font

func apply_menu_button_styles(btn: Button) -> void:
	var radius = 12
	var normal = StyleBoxFlat.new()
	normal.bg_color = Color(0.1, 0.08, 0.18, 0.92)
	normal.corner_radius_top_left = radius
	normal.corner_radius_top_right = radius
	normal.corner_radius_bottom_left = radius
	normal.corner_radius_bottom_right = radius
	normal.border_width_left = 2
	normal.border_width_top = 2
	normal.border_width_right = 2
	normal.border_width_bottom = 2
	normal.border_color = Color(0.45, 0.4, 0.55, 0.85)
	normal.content_margin_left = 16
	normal.content_margin_right = 16
	normal.content_margin_top = 10
	normal.content_margin_bottom = 10

	var hover = normal.duplicate()
	hover.bg_color = Color(0.14, 0.12, 0.26, 0.96)
	hover.border_color = Color(0.65, 0.58, 0.75, 0.95)

	var pressed = normal.duplicate()
	pressed.bg_color = Color(0.06, 0.05, 0.12, 0.98)
	pressed.border_color = Color(0.35, 0.32, 0.45, 0.9)

	var focus = StyleBoxFlat.new()
	focus.bg_color = Color(0.95, 0.78, 0.08, 1.0)
	focus.corner_radius_top_left = radius
	focus.corner_radius_top_right = radius
	focus.corner_radius_bottom_left = radius
	focus.corner_radius_bottom_right = radius
	focus.border_width_left = 5
	focus.border_width_top = 5
	focus.border_width_right = 5
	focus.border_width_bottom = 5
	focus.border_color = Color(1.0, 1.0, 1.0, 1.0)
	focus.content_margin_left = 16
	focus.content_margin_right = 16
	focus.content_margin_top = 10
	focus.content_margin_bottom = 10

	btn.add_stylebox_override("normal", normal)
	btn.add_stylebox_override("hover", hover)
	btn.add_stylebox_override("pressed", pressed)
	btn.add_stylebox_override("focus", focus)
	btn.add_color_override("font_color", Color.white)
	btn.add_color_override("font_color_hover", Color.white)
	btn.add_color_override("font_color_pressed", Color(0.92, 0.92, 1.0))
	btn.add_color_override("font_color_focus", Color(0.12, 0.09, 0.02))

func complete_mission(mission_index: int) -> void:
	if mission_index in missions_completed:
		return
	missions_completed.append(mission_index)

	var badge = mission_data[mission_index].badge
	badges_earned.append(badge)
	emit_signal("badge_earned", badge)

	if missions_completed.size() >= mission_data.size():
		emit_signal("game_completed")
	else:
		var next = mission_index + 1
		if next < mission_data.size():
			emit_signal("mission_unlocked", next)

func get_mission(index: int) -> Dictionary:
	if index >= 0 and index < mission_data.size():
		return mission_data[index]
	return {}

func get_pup(pup_id: String) -> Dictionary:
	if pup_id in pup_data:
		return pup_data[pup_id]
	return {}

func advance_to_next_mission() -> void:
	complete_mission(current_mission)
	current_mission += 1
	if current_mission < mission_data.size():
		MissionManager.load_mission(current_mission)

func get_zone_colors(zone: String) -> Dictionary:
	var palettes = {
		"town": {"bg": Color(0.25, 0.45, 0.8), "accent": Color(0.35, 0.55, 0.9), "star": Color(1.0, 0.9, 0.3), "text_accent": Color(1.0, 0.95, 0.5)},
		"farm": {"bg": Color(0.35, 0.6, 0.25), "accent": Color(0.45, 0.7, 0.35), "star": Color(1.0, 0.9, 0.3), "text_accent": Color(1.0, 0.95, 0.5)},
		"garden": {"bg": Color(0.7, 0.35, 0.55), "accent": Color(0.8, 0.45, 0.65), "star": Color(1.0, 0.85, 0.95), "text_accent": Color(1.0, 0.85, 0.95)},
		"beach": {"bg": Color(0.2, 0.55, 0.7), "accent": Color(0.3, 0.65, 0.8), "star": Color(1.0, 0.95, 0.6), "text_accent": Color(1.0, 0.95, 0.5)},
		"yard": {"bg": Color(0.7, 0.55, 0.2), "accent": Color(0.8, 0.65, 0.3), "star": Color(1.0, 1.0, 0.6), "text_accent": Color(1.0, 1.0, 0.7)},
		"hill": {"bg": Color(0.4, 0.3, 0.65), "accent": Color(0.5, 0.4, 0.75), "star": Color(0.9, 0.8, 1.0), "text_accent": Color(0.92, 0.85, 1.0)},
	}
	return palettes.get(zone, palettes["town"])

func reset_game() -> void:
	current_mission = 0
	missions_completed = []
	badges_earned = []
	collectibles_total = 0

func _schedule_cmdline_qa_mission() -> void:
	var idx = _parse_cmdline_mission_index()
	if idx < 0:
		return
	if idx >= mission_data.size():
		push_warning("QA --mission: index out of range (0..%d): %d" % [mission_data.size() - 1, idx])
		return
	call_deferred("_deferred_cmdline_load_mission", idx)

func _deferred_cmdline_load_mission(idx: int) -> void:
	MissionManager.load_mission(idx)

func _parse_cmdline_mission_index() -> int:
	var args = OS.get_cmdline_args()
	var i = 0
	while i < args.size():
		var a = String(args[i])
		if a == "--mission":
			if i + 1 >= args.size():
				push_warning("QA --mission needs a value (0-based mission index)")
				return -1
			var nxt = String(args[i + 1])
			if not nxt.is_valid_integer():
				push_warning("QA --mission value is not an integer: %s" % nxt)
				return -1
			return int(nxt)
		if a.begins_with("--mission="):
			var tail = a.substr(String("--mission=").length())
			if tail.empty() or not tail.is_valid_integer():
				push_warning("QA --mission= expects integer (0-based mission index)")
				return -1
			return int(tail)
		i += 1
	return -1
