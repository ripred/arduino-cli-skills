#!/usr/bin/env bash
set -u

REPO_ROOT="/Volumes/trent/Documents/Arduino/Arduino_CLI_Codex_Skills"
CONFIG_DIR="/tmp/arduino_cli_suite_icl_data"
PROJECT_DIR="$REPO_ROOT/tmp/icl_capture/project"
SKETCH_NAME="icl_suite_demo_v2"
SKETCH_DIR="$PROJECT_DIR/$SKETCH_NAME"
SKETCH_FILE="$SKETCH_DIR/$SKETCH_NAME.ino"
LOG_DIR="$REPO_ROOT/tmp/icl_capture/logs"
LOG_FILE="$LOG_DIR/non_hardware_success.log"

mkdir -p "$PROJECT_DIR" "$LOG_DIR"
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

run "rm -rf \"$CONFIG_DIR\""

run "$AR version"
run "$AR config init --overwrite"
run "$AR config dump"

run "$AR core update-index"
run "$AR core search arduino:avr"
run "$AR core install arduino:avr"
run "$AR core list"
run "$AR board details -b arduino:avr:uno"

run "$AR lib update-index"
run "$AR lib search ArduinoJson"
run "$AR lib install ArduinoJson@6.21.4"
run "$AR lib list"
run "$AR lib deps ArduinoJson"
run "$AR lib examples ArduinoJson"

run "$AR sketch new \"$SKETCH_DIR\""
run "printf '%s\n' '#include <ArduinoJson.h>' '' 'const int LED_PIN = LED_BUILTIN;' 'StaticJsonDocument<128> statusDoc;' '' 'void setup() {' '  Serial.begin(9600);' '  pinMode(LED_PIN, OUTPUT);' '  statusDoc[\"profile\"] = \"uno-dev\";' '  statusDoc[\"note\"] = \"icl example\";' '}' '' 'void loop() {' '  digitalWrite(LED_PIN, !digitalRead(LED_PIN));' '  serializeJson(statusDoc, Serial);' '  Serial.println();' '  delay(500);' '}' > \"$SKETCH_FILE\""

run "$AR profile create --profile uno-dev --fqbn arduino:avr:uno --set-default \"$SKETCH_DIR\""
run "$AR profile lib add ArduinoJson@6.21.4 --profile uno-dev --sketch-path \"$SKETCH_DIR\""
run "$AR profile set-default uno-dev --sketch-path \"$SKETCH_DIR\""

run "$AR board list"
run "$AR board search uno"
run "$AR board listall uno"
run "$AR board attach -b arduino:avr:uno \"$SKETCH_DIR\""

run "$AR compile -b arduino:avr:uno --output-dir \"$PROJECT_DIR/build_manual\" \"$SKETCH_DIR\""
run "$AR compile -m uno-dev --output-dir \"$PROJECT_DIR/build_profile\" \"$SKETCH_DIR\""
run "$AR compile -m uno-dev --dump-profile \"$SKETCH_DIR\""

run "$AR outdated"
run "$AR update --show-outdated"

run "$AR debug check -b arduino:avr:uno \"$SKETCH_DIR\""

run "$AR sketch archive \"$SKETCH_DIR\""
