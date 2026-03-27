"""OKAI Crew 모듈 템플릿.

프로젝트에 맞게 이름을 변경하고 로직을 구현하세요.
"""

from __future__ import annotations

import json
import time
from pathlib import Path

import yaml

# ── 경로 ──

PROJECT_ROOT = Path(__file__).parent.parent
CONFIG_PATH = PROJECT_ROOT / "config" / "config.yaml"
CREDENTIALS_PATH = PROJECT_ROOT / ".credentials" / "credentials.json"


# ── 설정 로드 ──

def load_config() -> dict:
    if CONFIG_PATH.exists():
        return yaml.safe_load(CONFIG_PATH.read_text(encoding="utf-8")) or {}
    return {}


def load_credentials() -> dict:
    """자격증명 로드. 없으면 FileNotFoundError."""
    if not CREDENTIALS_PATH.exists():
        raise FileNotFoundError(
            f"자격증명 파일 없음: {CREDENTIALS_PATH}\n"
            f"  설정: bash bin/setup.sh"
        )
    return json.loads(CREDENTIALS_PATH.read_text(encoding="utf-8"))


CFG = load_config()


# ── 메인 로직 ──

def run(action: str, quiet: bool = False, **params) -> bool:
    """메인 실행 함수.

    Args:
        action: 실행할 액션
        quiet: True이면 로그 최소화
        **params: 추가 파라미터

    Returns:
        성공 여부
    """
    if not quiet:
        print(f"[{action}] 실행 중...")

    # TODO: 프로젝트 로직 구현

    if not quiet:
        print(f"[{action}] 완료")
    return True
