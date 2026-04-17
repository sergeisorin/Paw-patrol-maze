extends Node

var _sfx_players: Dictionary = {}
var _music_player: AudioStreamPlayer = null
var _current_music: String = ""

var sfx_paths: Dictionary = {
	"tap": "res://assets/audio/sfx/tap_confirm.wav",
	"sparkle": "res://assets/audio/sfx/sparkle.wav",
	"reward": "res://assets/audio/sfx/reward_chime.wav",
	"swoosh": "res://assets/audio/sfx/swoosh.wav",
	"stone": "res://assets/audio/sfx/stone_place.wav",
	"balloon": "res://assets/audio/sfx/balloon_pop.wav",
	"quack": "res://assets/audio/sfx/duck_quack.wav",
	"cheer": "res://assets/audio/sfx/crowd_cheer.wav",
	"confetti": "res://assets/audio/sfx/confetti.wav",
	"hint": "res://assets/audio/sfx/hint_glow.wav",
}

var music_paths: Dictionary = {
	"menu": "res://assets/audio/music/menu_theme.wav",
	"adventure": "res://assets/audio/music/adventure_loop.wav",
	"celebration": "res://assets/audio/music/celebration.wav",
}

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Master"
	_music_player.volume_db = -6
	add_child(_music_player)

	for key in sfx_paths:
		var player = AudioStreamPlayer.new()
		player.bus = "Master"
		player.volume_db = -3
		add_child(player)
		var stream = load(sfx_paths[key])
		if stream:
			player.stream = stream
		_sfx_players[key] = player

func play_sfx(sfx_name: String) -> void:
	if sfx_name in _sfx_players:
		var player = _sfx_players[sfx_name]
		if player.stream:
			player.play()

func play_music(music_name: String) -> void:
	if music_name == _current_music and _music_player.playing:
		return
	_current_music = music_name
	if music_name in music_paths:
		var stream = load(music_paths[music_name])
		if stream:
			_music_player.stream = stream
			_music_player.play()

func stop_music() -> void:
	_music_player.stop()
	_current_music = ""

func fade_music(duration: float = 1.0) -> void:
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(_music_player, "volume_db", _music_player.volume_db, -40, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	_music_player.stop()
	_music_player.volume_db = -6
	tween.queue_free()
