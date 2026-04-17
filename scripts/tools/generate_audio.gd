extends SceneTree

var SAMPLE_RATE = 22050

func _init() -> void:
	print("=== Generating placeholder audio ===")
	_generate_sfx_tap(0.3, "res://assets/audio/sfx/tap_confirm.wav")
	_generate_sfx_sparkle(0.5, "res://assets/audio/sfx/sparkle.wav")
	_generate_sfx_chime(0.6, "res://assets/audio/sfx/reward_chime.wav")
	_generate_sfx_swoosh(0.3, "res://assets/audio/sfx/swoosh.wav")
	_generate_sfx_thud(0.25, "res://assets/audio/sfx/stone_place.wav")
	_generate_sfx_pop(0.2, "res://assets/audio/sfx/balloon_pop.wav")
	_generate_sfx_quack(0.35, "res://assets/audio/sfx/duck_quack.wav")
	_generate_sfx_cheer(1.0, "res://assets/audio/sfx/crowd_cheer.wav")
	_generate_sfx_confetti(0.6, "res://assets/audio/sfx/confetti.wav")
	_generate_sfx_hint(0.4, "res://assets/audio/sfx/hint_glow.wav")
	_generate_music_loop(8.0, "res://assets/audio/music/menu_theme.wav")
	_generate_music_adventure(8.0, "res://assets/audio/music/adventure_loop.wav")
	_generate_music_celebration(6.0, "res://assets/audio/music/celebration.wav")
	print("=== Audio generation complete! ===")
	quit()

func _generate_sfx_tap(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var env = max(0, 1.0 - t / duration)
		env = env * env
		samples[i] = sin(t * 880 * TAU) * 0.3 * env + sin(t * 1320 * TAU) * 0.2 * env
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_sfx_sparkle(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var env = max(0, 1.0 - t / duration)
		var freq = 2000 + sin(t * 6) * 500
		samples[i] = sin(t * freq * TAU) * 0.15 * env + sin(t * freq * 1.5 * TAU) * 0.1 * env * env
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_sfx_chime(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	var notes = [523.25, 659.25, 783.99, 1046.5]
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var val = 0.0
		for n_idx in range(notes.size()):
			var note_start = n_idx * 0.12
			var note_t = t - note_start
			if note_t >= 0:
				var note_env = max(0, 1.0 - note_t / (duration - note_start))
				note_env = note_env * note_env
				val += sin(note_t * notes[n_idx] * TAU) * 0.2 * note_env
		samples[i] = val
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_sfx_swoosh(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	seed(42)
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var env = sin(t / duration * PI)
		samples[i] = (randf() * 2.0 - 1.0) * 0.2 * env
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_sfx_thud(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var env = max(0, 1.0 - t / duration)
		env = env * env * env
		var freq = 120 * (1.0 + env * 2.0)
		samples[i] = sin(t * freq * TAU) * 0.4 * env
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_sfx_pop(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var env = max(0, 1.0 - t / duration)
		env = env * env
		var freq = 600 + (1.0 - t / duration) * 400
		samples[i] = sin(t * freq * TAU) * 0.25 * env + sin(t * 1200 * TAU) * 0.1 * env * env
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_sfx_quack(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var env = 0.0
		if t < 0.05:
			env = t / 0.05
		elif t < 0.15:
			env = 1.0
		else:
			env = max(0, 1.0 - (t - 0.15) / 0.2)
		var freq = 350 + sin(t * 15) * 50
		samples[i] = sin(t * freq * TAU) * 0.3 * env
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_sfx_cheer(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	seed(99)
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var env = 0.0
		if t < 0.2:
			env = t / 0.2
		elif t < 0.7:
			env = 1.0
		else:
			env = max(0, 1.0 - (t - 0.7) / 0.3)
		var noise = (randf() * 2.0 - 1.0) * 0.15
		var tone = sin(t * 300 * TAU) * 0.05 + sin(t * 450 * TAU) * 0.03
		samples[i] = (noise + tone) * env
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_sfx_confetti(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	seed(77)
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var env = max(0, 1.0 - t / duration)
		var noise = (randf() * 2.0 - 1.0) * 0.08
		var shimmer = sin(t * 3000 * TAU) * 0.05 * sin(t * 7 * TAU)
		samples[i] = (noise + shimmer) * env
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_sfx_hint(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var env = sin(t / duration * PI) * 0.5
		var freq = 800 + sin(t * 3) * 200
		samples[i] = sin(t * freq * TAU) * 0.12 * env
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_music_loop(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	var melody = [262, 294, 330, 349, 392, 440, 392, 349, 330, 294, 262, 262, 330, 392, 523, 440]
	var note_dur = duration / melody.size()

	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var note_idx = int(t / note_dur) % melody.size()
		var note_t = fmod(t, note_dur)
		var note_env = 1.0 - note_t / note_dur * 0.5
		var freq = melody[note_idx]

		var val = sin(t * freq * TAU) * 0.15 * note_env
		val += sin(t * freq * 2 * TAU) * 0.05 * note_env
		val += sin(t * 130 * TAU) * 0.06
		samples[i] = val
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_music_adventure(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	var melody = [330, 392, 440, 523, 494, 440, 392, 330, 349, 440, 523, 587, 523, 440, 349, 330]
	var bass = [130, 130, 165, 165, 196, 196, 165, 165, 175, 175, 220, 220, 196, 196, 175, 130]
	var note_dur = duration / melody.size()

	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var note_idx = int(t / note_dur) % melody.size()
		var note_t = fmod(t, note_dur)
		var note_env = 1.0 - note_t / note_dur * 0.4

		var val = sin(t * melody[note_idx] * TAU) * 0.12 * note_env
		val += sin(t * melody[note_idx] * 2 * TAU) * 0.04 * note_env
		val += sin(t * bass[note_idx] * TAU) * 0.08

		var beat_pos = fmod(t, note_dur * 4)
		if beat_pos < 0.02:
			val += 0.1

		samples[i] = val
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

func _generate_music_celebration(duration: float, path: String) -> void:
	var samples = _make_samples(duration)
	var fanfare = [523, 659, 784, 1047, 784, 1047, 1047, 0, 523, 659, 784, 1047]
	var note_dur = duration / fanfare.size()

	for i in range(samples.size()):
		var t = float(i) / SAMPLE_RATE
		var note_idx = int(t / note_dur) % fanfare.size()
		var note_t = fmod(t, note_dur)
		var freq = fanfare[note_idx]

		if freq == 0:
			samples[i] = 0.0
			continue

		var env = 1.0 - note_t / note_dur * 0.3
		var val = sin(t * freq * TAU) * 0.15 * env
		val += sin(t * freq * 2 * TAU) * 0.06 * env
		val += sin(t * freq * 3 * TAU) * 0.03 * env

		val += sin(t * 262 * TAU) * 0.06
		samples[i] = val
	_save_wav(samples, path)
	print("  Generated: " + path.get_file())

# ─── WAV helpers ───

func _make_samples(duration: float) -> Array:
	var count = int(duration * SAMPLE_RATE)
	var arr = []
	arr.resize(count)
	for i in range(count):
		arr[i] = 0.0
	return arr

func _save_wav(samples: Array, path: String) -> void:
	var file = File.new()
	if file.open(path, File.WRITE) != OK:
		push_error("Cannot write: " + path)
		return

	var num_samples = samples.size()
	var byte_rate = SAMPLE_RATE * 2
	var data_size = num_samples * 2

	file.store_string("RIFF")
	file.store_32(36 + data_size)
	file.store_string("WAVE")

	file.store_string("fmt ")
	file.store_32(16)
	file.store_16(1)
	file.store_16(1)
	file.store_32(SAMPLE_RATE)
	file.store_32(byte_rate)
	file.store_16(2)
	file.store_16(16)

	file.store_string("data")
	file.store_32(data_size)

	for s in samples:
		var clamped = clamp(s, -1.0, 1.0)
		var val = int(clamped * 32767)
		if val < 0:
			val = 65536 + val
		file.store_16(val)

	file.close()
