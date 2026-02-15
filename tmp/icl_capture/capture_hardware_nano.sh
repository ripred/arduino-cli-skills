#!/usr/bin/env bash
set -u

REPO_ROOT="/Volumes/trent/Documents/Arduino/Arduino_CLI_Codex_Skills"
CONFIG_DIR="/tmp/arduino_cli_suite_icl_data"
SKETCH_DIR="$REPO_ROOT/tmp/icl_capture/project/icl_suite_demo_v2"
LOG_FILE="$REPO_ROOT/tmp/icl_capture/logs/hardware_nano.log"

mkdir -p "$REPO_ROOT/tmp/icl_capture/logs"
: > "$LOG_FILE"

AR="arduino-cli --config-dir \"$CONFIG_DIR\""

PORT="$(arduino-cli --config-dir "$CONFIG_DIR" board list | awk '/usbserial|usbmodem/ {print $1; exit}')"
if [ -z "$PORT" ]; then
  echo "No USB serial Arduino-like port found." | tee -a "$LOG_FILE"
  exit 1
fi

FQBN="arduino:avr:nano:cpu=atmega328old"

run() {
  local cmd="$1"
  echo "" | tee -a "$LOG_FILE"
  echo "### CMD: $cmd" | tee -a "$LOG_FILE"
  bash -lc "$cmd" 2>&1 | tee -a "$LOG_FILE"
  local code=${PIPESTATUS[0]}
  echo "### EXIT: $code" | tee -a "$LOG_FILE"
}

run "$AR board list"
run "$AR board search nano"
run "$AR board listall nano"
run "$AR board details -b arduino:avr:nano"
run "$AR board attach -p $PORT -b $FQBN \"$SKETCH_DIR\""

run "$AR profile create --profile nano-old --fqbn $FQBN --set-default \"$SKETCH_DIR\""
run "$AR profile lib add ArduinoJson@6.21.4 --profile nano-old --sketch-path \"$SKETCH_DIR\""

run "$AR compile -b $FQBN --output-dir \"$REPO_ROOT/tmp/icl_capture/project/build_nano_old\" \"$SKETCH_DIR\""
run "$AR compile -m nano-old --output-dir \"$REPO_ROOT/tmp/icl_capture/project/build_nano_profile\" \"$SKETCH_DIR\""

run "$AR upload -p $PORT -b $FQBN \"$SKETCH_DIR\""

run "$AR monitor --describe -p $PORT"

run "$AR debug check -b $FQBN \"$SKETCH_DIR\""

run "$AR profile set-default uno-dev --sketch-path \"$SKETCH_DIR\""
