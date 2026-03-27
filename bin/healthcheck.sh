#!/bin/bash
# OKAI Crew 헬스체크
#
# 사용법: bash bin/healthcheck.sh
# 출력: JSON (stdout)
#
# OKAI 마더 프로젝트에서 crew 실행 전 호출:
#   result=$(bash crew-NAME/bin/healthcheck.sh 2>/dev/null)

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CREW_NAME="$(basename "$SCRIPT_DIR")"

checks=""
errors=0
warnings=0

add_check() {
    local name="$1" status="$2" message="$3" fix="${4:-}"
    [ -n "$checks" ] && checks="$checks,"
    checks="$checks{\"name\":\"$name\",\"status\":\"$status\",\"message\":\"$message\""
    if [ -n "$fix" ]; then
        checks="$checks,\"fix\":\"$fix\""
    fi
    checks="$checks}"
    [ "$status" = "fail" ] && errors=$((errors + 1))
    [ "$status" = "warn" ] && warnings=$((warnings + 1))
}

# ── 공통 체크 ──

# macOS
if [[ "$(uname)" == "Darwin" ]]; then
    add_check "macos" "pass" "macOS 확인"
else
    add_check "macos" "fail" "macOS 필요 (현재: $(uname))" ""
fi

# Python 3
if command -v python3 &>/dev/null; then
    py_ver=$(python3 --version 2>&1 | awk '{print $2}')
    add_check "python" "pass" "Python $py_ver"
else
    add_check "python" "fail" "Python 3 미설치" "brew install python3"
fi

# Python 패키지 (requirements.txt 기반)
if [ -f "$SCRIPT_DIR/requirements.txt" ]; then
    missing_pkgs=""
    while IFS= read -r line; do
        pkg=$(echo "$line" | sed 's/[>=<].*//' | tr -d '[:space:]')
        [ -z "$pkg" ] && continue
        [[ "$pkg" == \#* ]] && continue
        # pip 패키지명 → import 이름 변환
        import_name=$(echo "$pkg" | tr '-' '_' | tr '[:upper:]' '[:lower:]')
        if ! python3 -c "import $import_name" 2>/dev/null; then
            missing_pkgs="$missing_pkgs $pkg"
        fi
    done < "$SCRIPT_DIR/requirements.txt"
    if [ -z "$missing_pkgs" ]; then
        add_check "python_packages" "pass" "Python 패키지 설치됨"
    else
        add_check "python_packages" "fail" "Python 패키지 누락:$missing_pkgs" "pip install -r requirements.txt"
    fi
fi

# 자격증명
cred_dir="$SCRIPT_DIR/.credentials"
cred_files=$(find "$cred_dir" -name "*.json" 2>/dev/null | head -1)
if [ -n "$cred_files" ]; then
    add_check "credentials" "pass" "자격증명 설정됨"
else
    if [ -f "$SCRIPT_DIR/bin/setup.sh" ]; then
        add_check "credentials" "fail" "자격증명 미설정" "bash bin/setup.sh"
    else
        add_check "credentials" "warn" "자격증명 파일 없음" ""
    fi
fi

# config 파일
config_files=$(find "$SCRIPT_DIR/config" -name "*.yaml" -o -name "*.json" 2>/dev/null | head -1)
if [ -n "$config_files" ]; then
    add_check "config" "pass" "설정 파일 존재"
else
    add_check "config" "warn" "config/ 설정 파일 없음" ""
fi

# Claude CLI (선택)
if command -v claude &>/dev/null; then
    add_check "claude_cli" "pass" "Claude CLI 설치됨"
else
    add_check "claude_cli" "warn" "Claude CLI 미설치 (AI 기능 제한)" "npm install -g @anthropic-ai/claude-code"
fi

# ── 프로젝트별 체크 추가 ──
# 아래에 프로젝트 고유 체크를 추가하세요:
#
# add_check "custom_check" "pass" "설명" "해결방법"

# ── 결과 출력 ──

if [ $errors -gt 0 ]; then
    status="fail"
elif [ $warnings -gt 0 ]; then
    status="warn"
else
    status="pass"
fi

cat <<EOF
{
  "crew": "$CREW_NAME",
  "status": "$status",
  "errors": $errors,
  "warnings": $warnings,
  "checks": [$checks]
}
EOF
