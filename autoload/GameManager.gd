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
]

func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS
	_font_data_bold = DynamicFontData.new()
	_font_data_bold.font_path = "res://assets/fonts/NotoSans-Bold.ttf"
	_font_data_regular = DynamicFontData.new()
	_font_data_regular.font_path = "res://assets/fonts/NotoSans-Regular.ttf"

func make_font(size: int, bold: bool = true) -> DynamicFont:
	var font = DynamicFont.new()
	font.font_data = _font_data_bold if bold else _font_data_regular
	font.size = size
	return font

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
