# crew-template

OKAI 플랫폼의 crew 모듈 템플릿. 새 crew 프로젝트를 빠르게 시작할 수 있습니다.

## 사용법

1. 이 레포를 template으로 새 레포 생성
2. 프로젝트명으로 변경: `crew-{서비스명}`
3. 아래 체크리스트 따라 커스터마이즈

## 초기 설정 체크리스트

- [ ] `README.md` — 프로젝트 설명으로 교체
- [ ] `CLAUDE.md` — 프로젝트 아키텍처 작성
- [ ] `bin/main.sh` — 메인 엔트리 구현
- [ ] `bin/setup.sh` — 자격증명 항목 수정
- [ ] `bin/healthcheck.sh` — 프로젝트별 체크 추가
- [ ] `lib/example.py` → `lib/{모듈명}.py` — 핵심 로직 구현
- [ ] `config/config.example.yaml` → `config/{설정명}.yaml`
- [ ] `config/prompts/` — AI 프롬프트 템플릿 작성
- [ ] `requirements.txt` — 의존성 추가

## 프로젝트 구조

```
crew-NAME/
├── bin/
│   ├── main.sh              # 메인 엔트리 (외부 호출용)
│   ├── setup.sh             # 자격증명 설정 (대화형)
│   └── healthcheck.sh       # 환경 검증 (JSON 출력)
├── lib/
│   ├── common.sh            # Bash 공통 유틸리티 (경로, 로깅)
│   └── example.py           # Python 모듈 템플릿
├── config/
│   ├── config.example.yaml  # 설정 예시
│   └── prompts/             # Claude AI 프롬프트 템플릿
├── data/                    # 런타임 데이터 (.gitignore)
│   ├── memory/              # 학습 데이터 (이력, 로그)
│   └── queue/               # 작업 큐 (JSON 파일 기반)
├── .credentials/            # 자격증명 (.gitignore)
│   └── README.md            # 설정 안내
├── CLAUDE.md                # Claude Code 개발 가이드
├── CHANGELOG.md             # 변경 이력
└── README.md
```

## OKAI 연동

### module_call

```json
{
  "type": "module_call",
  "target": "crew-NAME",
  "action": "run",
  "params": {"key": "value"}
}
```

### Python 직접 호출

```python
from lib.example import run
success = run(action="do_something", quiet=True)
```

### 헬스체크

```bash
result=$(bash crew-NAME/bin/healthcheck.sh 2>/dev/null)
# {"crew":"crew-NAME","status":"pass|warn|fail","errors":0,"checks":[...]}
```

## 규칙

- `bin/` — 외부에서 호출하는 실행 파일만
- `lib/` — 재사용 가능한 라이브러리
- `config/` — 버전 관리되는 설정 (비밀정보 제외)
- `data/` — 런타임 생성 데이터 (git 제외)
- `.credentials/` — 비밀정보 (git 제외, chmod 600)
- 헬스체크는 JSON 출력 (마더 프로젝트 파싱용)
