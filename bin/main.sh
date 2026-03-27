#!/bin/bash
# OKAI Crew 메인 엔트리
#
# 사용법:
#   bash bin/main.sh <action> [args...]
#   bash bin/main.sh --status
#   bash bin/main.sh --help

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SCRIPT_DIR"

exec python3 -c "
import sys
sys.path.insert(0, '.')

args = sys.argv[1:]

if '--help' in args or '-h' in args:
    print('사용법: main.sh <action> [args...]')
    print('       main.sh --status')
    sys.exit(0)

if '--status' in args:
    print('상태: 정상')
    sys.exit(0)

quiet = '-q' in args or '--quiet' in args
clean_args = [a for a in args if a not in ('-q', '--quiet')]

if len(clean_args) < 1:
    print('사용법: main.sh <action> [args...]')
    sys.exit(1)

# ── 프로젝트에 맞게 수정하세요 ──
# from lib.example import run
# ok = run(action=clean_args[0], quiet=quiet)
# sys.exit(0 if ok else 1)

print(f'action: {clean_args[0]}, args: {clean_args[1:]}')
" "\$@"
