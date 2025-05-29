#!/bin/bash

PROCESS_NAME="test"
MONITORING_URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
TIMEOUT=10

is_process_running() {
    pgrep -x "$PROCESS_NAME" >/dev/null
}

was_process_restarted() {
    local current_pid=$(pgrep -x "$PROCESS_NAME")
    local last_pid_file="/tmp/last_${PROCESS_NAME}_pid"
    
    if [[ -f "$last_pid_file" ]]; then
        local last_pid=$(cat "$last_pid_file")
        if [[ "$last_pid" != "$current_pid" && -n "$current_pid" ]]; then
            echo "$current_pid" > "$last_pid_file"
            return 0
        fi
    else
        [[ -n "$current_pid" ]] && echo "$current_pid" > "$last_pid_file"
    fi
    
    return 1
}

send_monitoring_request() {
    if ! curl -s -k --max-time "$TIMEOUT" "$MONITORING_URL" >/dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: Monitoring server is not reachable" >> "$LOG_FILE"
        return 1
    fi
    return 0
}

main() {
    if is_process_running; then
        if was_process_restarted; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - INFO: Process $PROCESS_NAME was restarted" >> "$LOG_FILE"
        fi
        send_monitoring_request
    fi
}

main
