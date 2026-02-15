#!/usr/bin/env bash
set -u

REPO_ROOT="/Volumes/trent/Documents/Arduino/Arduino_CLI_Codex_Skills"
CONFIG_DIR="$REPO_ROOT/tmp/icl_capture/arduino_data"
PROJECT_DIR="$REPO_ROOT/tmp/icl_capture/project"
SKETCH_DIR="$PROJECT_DIR/icl_suite_demo"
LOG_DIR="$REPO_ROOT/tmp/icl_capture/logs"
LOG_FILE="$LOG_DIR/non_hardware_session.log"

mkdir -p "$CONFIG_DIR" "$PROJECT_DIR" "$LOG_DIR"
: > "$LOG_FILE"

AR="arduino-cli --config-dir \"$CONFIG_DIR\""

run() {
  local cmd="$1"
  echo "" | tee -a "$LOG_FILE"
  echo "### CMD: $cmd" | tee -a "$LOG_FILE"
  bash -lc "$cmd" 2>&1 | tee -a "$LOG_FILE"
  local code=${PIPESTATUS[0]}
  echo "### EXIT: $code" | tee -a "$LOG_FILE"
}

run "$AR version"
run "$AR help"
run "$AR completion bash | sed -n '1,30p'"

run "$AR config init --overwrite"
run "$AR config dump"
run "$AR config add board_manager.additional_urls https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json"
run "$AR config get board_manager.additional_urls"
run "$AR config remove board_manager.additional_urls https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json"
run "$AR config get board_manager.additional_urls"

run "$AR core update-index"
run "$AR core search arduino:avr"
run "$AR core install arduino:avr"
run "$AR core list"
run "$AR core download arduino:avr@1.8.6"

run "$AR lib update-index"
run "$AR lib search ArduinoJson"
run "$AR lib install ArduinoJson@6.21.4"
run "$AR lib list"
run "$AR lib deps ArduinoJson"
run "$AR lib examples ArduinoJson"
run "mkdir -p \"$PROJECT_DIR/downloads\""
run "cd \"$PROJECT_DIR/downloads\" && $AR lib download ArduinoJson@6.21.4"

run "$AR sketch new \"$SKETCH_DIR\""

run "$AR profile create --profile uno-dev --fqbn arduino:avr:uno --set-default \"$SKETCH_DIR\""
run "$AR profile lib add ArduinoJson@6.21.4 --profile uno-dev --sketch-path \"$SKETCH_DIR\""
run "$AR profile lib remove ArduinoJson@6.21.4 --profile uno-dev --sketch-path \"$SKETCH_DIR\""
run "$AR profile lib add ArduinoJson@6.21.4 --profile uno-dev --sketch-path \"$SKETCH_DIR\""
run "$AR profile set-default uno-dev \"$SKETCH_DIR\""

run "$AR board list"
run "$AR board search uno"
run "$AR board listall uno"
run "$AR board details -b arduino:avr:uno"
run "$AR board attach -b arduino:avr:uno \"$SKETCH_DIR\""

run "$AR compile -b arduino:avr:uno --output-dir \"$PROJECT_DIR/build_manual\" \"$SKETCH_DIR\""
run "$AR compile -m uno-dev --output-dir \"$PROJECT_DIR/build_profile\" \"$SKETCH_DIR\""
run "$AR compile -m uno-dev --dump-profile \"$SKETCH_DIR\""

run "$AR outdated"
run "$AR update --show-outdated"

run "$AR debug check -b arduino:avr:uno \"$SKETCH_DIR\""

run "$AR sketch archive \"$SKETCH_DIR\""
