#!/bin/bash
# OKAI Crew 공통 유틸리티
#
# 모든 bin/ 스크립트에서 source:
#   source "$LIB_DIR/common.sh"

set -uo pipefail

# ── 경로 ──
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$PROJECT_ROOT/bin"
LIB_DIR="$PROJECT_ROOT/lib"
CONFIG_DIR="$PROJECT_ROOT/config"
DATA_DIR="$PROJECT_ROOT/data"
LOG_DIR="$PROJECT_ROOT/logs"
MEMORY_DIR="$DATA_DIR/memory"
QUEUE_DIR="$DATA_DIR/queue"
CRED_DIR="$PROJECT_ROOT/.credentials"

# 런타임 디렉토리 생성
mkdir -p "$LOG_DIR" "$MEMORY_DIR" "$QUEUE_DIR"

# ── 로깅 ──
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $*" >&2
}

# ── 자격증명 ──
load_credentials() {
    local cred_file="$CRED_DIR/credentials.json"
    if [ ! -f "$cred_file" ]; then
        log_error "자격증명 파일 없음: $cred_file"
        log_error "설정: bash bin/setup.sh"
        return 1
    fi
    cat "$cred_file"
}

# ── 설정 ──
load_config() {
    local config_file="${1:-$CONFIG_DIR/config.yaml}"
    if [ ! -f "$config_file" ]; then
        log_error "설정 파일 없음: $config_file"
        return 1
    fi
    cat "$config_file"
}
