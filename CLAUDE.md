# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

OKAI 플랫폼의 crew 모듈 표준 템플릿. 새 crew 프로젝트(`crew-{서비스명}`)의 스캐폴딩을 제공한다.

## 핵심 명령어

```bash
# 메인 실행
bash bin/main.sh <action> [args...]
bash bin/main.sh <action> -q          # Quiet 모드
bash bin/main.sh --status             # 상태 확인

# 환경 검증 (JSON 출력)
bash bin/healthcheck.sh

# 자격증명 설정 (대화형)
bash bin/setup.sh
```

## 실행 전 필수

1. Python 3.6+ / `pip install -r requirements.txt`
2. 자격증명 설정: `bash bin/setup.sh`
3. 설정 파일 복사: `cp config/config.example.yaml config/config.yaml`

## 아키텍처

### 실행 흐름

```
bin/main.sh (CLI 엔트리)
  └─ source lib/common.sh (경로 변수, 로깅 함수)
  └─ python3 -c "from lib.example import run; run(action, quiet)"
       ├─ load_config()  → config/config.yaml (YAML, 선택)
       └─ load_credentials() → .credentials/credentials.json (JSON, 필수)
```

### 핵심 컴포넌트

- `bin/main.sh` — CLI 엔트리. action 인자를 파싱하여 Python `run()` 호출
- `lib/common.sh` — Bash 공통 유틸. 경로 상수(`PROJECT_ROOT`, `CONFIG_DIR`, `DATA_DIR` 등), `log()`, `log_error()`, `load_credentials()`, `load_config()` 제공. 모든 bin/ 스크립트에서 `source`
- `lib/example.py` — Python 핵심 로직 템플릿. `run(action, quiet, **params) -> bool` 패턴
- `bin/healthcheck.sh` — 환경 검증. macOS, Python, 패키지, 자격증명, 설정 파일, Claude CLI 순으로 체크. 결과는 JSON(`{"crew":"crew-NAME","status":"pass|warn|fail","checks":[...]}`)

### 디렉토리 규칙

| 디렉토리                       | 용도                      | Git |
| ------------------------------ | ------------------------- | --- |
| `bin/`                         | 외부 호출 실행 파일만     | O   |
| `lib/`                         | 재사용 라이브러리         | O   |
| `config/`                      | 설정 (비밀정보 제외)      | O   |
| `config/prompts/`              | Claude AI 프롬프트 템플릿 | O   |
| `data/memory/`, `data/queue/`  | 런타임 데이터             | X   |
| `.credentials/`                | 비밀정보 (chmod 600)      | X   |

## 템플릿 커스터마이즈

이 레포를 template으로 새 crew 생성 시 수정 포인트:

1. `lib/example.py` → `lib/{모듈명}.py`로 리네임 후 핵심 로직 구현
2. `bin/main.sh` — Python import 경로를 새 모듈명으로 변경
3. `bin/setup.sh` — 필요한 자격증명 항목(email/password 외) 수정
4. `bin/healthcheck.sh` — 95번째 줄 부근 프로젝트별 체크 추가
5. `config/prompts/` — AI 프롬프트 템플릿 작성 (변수: `{CREW_NAME}`, `{CONTEXT}`, `{DATA_FILE_PATH}`)

## OKAI 연동

```json
{
  "type": "module_call",
  "target": "crew-NAME",
  "action": "run",
  "params": {}
}
```
