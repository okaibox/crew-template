#!/bin/bash
# OKAI Crew 자격증명 설정
#
# 프로젝트에 맞게 수정하세요.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CRED_DIR="$SCRIPT_DIR/.credentials"
CRED_FILE="$CRED_DIR/credentials.json"

mkdir -p "$CRED_DIR"

CREW_NAME="$(basename "$SCRIPT_DIR")"
echo "$CREW_NAME 자격증명 설정"
echo "======================================"
echo ""

if [ -f "$CRED_FILE" ]; then
    echo "기존 자격증명 파일 발견: $CRED_FILE"
    read -p "덮어쓰시겠습니까? (y/N): " overwrite
    if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
        echo "취소됨"
        exit 0
    fi
fi

# ── 프로젝트에 맞게 수정하세요 ──
read -p "이메일: " email
read -sp "비밀번호: " password
echo ""

cat > "$CRED_FILE" << EOF
{
  "email": "$email",
  "password": "$password"
}
EOF

chmod 600 "$CRED_FILE"
echo ""
echo "저장 완료: $CRED_FILE"
echo "권한: 600 (소유자만 읽기/쓰기)"
