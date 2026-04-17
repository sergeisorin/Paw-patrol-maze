#!/bin/bash
# Generate Russian voice lines for all mission dialogue using edge-tts
# Uses DmitryNeural (male) for Райдер and male pups
# Uses SvetlanaNeural (female) for Скай

set -e

VOICE_DIR="$(cd "$(dirname "$0")/../../assets/audio/voice" && pwd)"
MALE="ru-RU-DmitryNeural"
FEMALE="ru-RU-SvetlanaNeural"

generate() {
    local voice="$1"
    local filename="$2"
    local text="$3"
    local rate="${4:---rate=+0%}"

    local mp3_path="$VOICE_DIR/${filename}.mp3"
    local wav_path="$VOICE_DIR/${filename}.wav"

    if [ -f "$wav_path" ]; then
        echo "  SKIP: $filename (exists)"
        return
    fi

    echo "  GEN:  $filename"
    edge-tts --voice "$voice" $rate --text "$text" --write-media "$mp3_path" 2>/dev/null
    ffmpeg -i "$mp3_path" -ar 22050 -ac 1 -y "$wav_path" 2>/dev/null
    rm -f "$mp3_path"
}

echo "=== Generating voice lines ==="

# --- MissionBase defaults ---
echo "[base]"
generate "$MALE" "base_intro"       "Нам нужна помощь!"
generate "$MALE" "base_celebration" "Отличная работа!"

# --- Mission 1: Chase & Balloon ---
echo "[mission1]"
generate "$MALE" "m1_intro_ryder"   "Мальчик потерял шарик в парке!"
generate "$MALE" "m1_intro_chase"   "Гонщик берётся за дело! Найдём шарик!" "--rate=+10%"
generate "$MALE" "m1_celeb_chase"   "Мы нашли шарик! Ура!" "--rate=+10%"
generate "$MALE" "m1_celeb_ryder"   "Отлично! Ты заработал Звезду Города!"

# --- Mission 2: Marshall & Hose ---
echo "[mission2]"
generate "$MALE" "m2_intro_ryder"     "Фермер Юми нужна вода для цветов!"
generate "$MALE" "m2_intro_marshall"  "Я горю от нетерпения! Найдём шланг!" "--rate=+10%"
generate "$MALE" "m2_celeb_marshall"  "Цветы спасены! Отлично!" "--rate=+10%"
generate "$MALE" "m2_celeb_ryder"     "Ты заработал Звезду Фермы!"

# --- Mission 3: Skye & Kitten ---
echo "[mission3]"
generate "$MALE"   "m3_intro_ryder"  "Котёнок заблудился в саду бабочек!"
generate "$FEMALE" "m3_intro_skye"   "Этот щенок полетит! Найдём котёнка!" "--rate=+5%"
generate "$FEMALE" "m3_celeb_skye"   "Котёнок найден! Мур-мур!" "--rate=+5%"
generate "$MALE"   "m3_celeb_ryder"  "Ты заработал Звезду Сада!"

# --- Mission 4: Zuma & Boat ---
echo "[mission4]"
generate "$MALE" "m4_intro_ryder"  "Игрушечный кораблик уплыл к дальнему причалу!"
generate "$MALE" "m4_intro_zuma"   "Ныряем! Найдём кораблик!" "--rate=+10%"
generate "$MALE" "m4_celeb_zuma"   "Кораблик найден! Плыви домой!" "--rate=+10%"
generate "$MALE" "m4_celeb_ryder"  "Ты заработал Звезду Моря!"

# --- Mission 5: Rubble & Road ---
echo "[mission5]"
generate "$MALE" "m5_intro_ryder"    "Дорога к площадке заблокирована!"
generate "$MALE" "m5_intro_rubble"   "Крепыш всегда готов! Найдём инструменты!" "--rate=+5%"
generate "$MALE" "m5_celeb_rubble"   "Дорога починена! Дети могут играть!" "--rate=+5%"
generate "$MALE" "m5_celeb_ryder"    "Ты заработал Звезду Стройки!"

# --- Mission 6: Rocky & Cart ---
echo "[mission6]"
generate "$MALE" "m6_intro_ryder"  "Тележка для уборки потерялась в саду!"
generate "$MALE" "m6_intro_rocky"  "Не выбрасывай — используй! Найдём тележку!" "--rate=+5%"
generate "$MALE" "m6_celeb_rocky"  "Тележка найдена! Парк будет чистым!" "--rate=+5%"
generate "$MALE" "m6_celeb_ryder"  "Ты заработал Звезду Переработки!"

# --- Mission 7: Team Lookout ---
echo "[mission7]"
generate "$MALE" "m7_intro_ryder"   "Все щенки собираются на Базе для праздника!"
generate "$MALE" "m7_intro_chase"   "Гонщик ведёт команду! Вперёд к Базе!" "--rate=+10%"
generate "$MALE" "m7_celeb_chase"   "Мы добрались до Базы!" "--rate=+10%"
generate "$MALE" "m7_celeb_ryder1"  "Все щенки в сборе! Ты настоящий герой!"
generate "$MALE" "m7_celeb_ryder2"  "Спасибо за помощь! Щенячий Патруль — вперёд!"

echo "=== Done! Generated $(ls "$VOICE_DIR"/*.wav 2>/dev/null | wc -l | tr -d ' ') voice files ==="
