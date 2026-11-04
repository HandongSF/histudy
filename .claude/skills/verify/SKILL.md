---
name: verify
description: 변경된 영역(backend/frontend)을 감지해 해당 영역의 테스트와 빌드를 실행합니다. 커밋이나 PR 전에 변경을 검증할 때 사용합니다.
---

# 영역별 검증

## 절차

1. 변경 영역을 정합니다: `git diff --name-only <base>...HEAD`와 `git status --short`를 합쳐 봅니다.
   - `backend/`로 시작하면 백엔드, `frontend/`로 시작하면 프런트엔드입니다.
   - `Dockerfile`, `docker-compose.yml`, `.dockerignore`, `.github/workflows/ci.yml`, `.github/workflows/deploy-dev.yml`이 바뀌었으면 두 영역 모두입니다(`ci.yml`의 `changes` 잡과 같은 규칙).
2. 해당 영역만 실행합니다.
   - 백엔드: `cd backend && ./gradlew clean test`
   - 프런트엔드: `cd frontend && pnpm install --frozen-lockfile && pnpm exec tsc --noEmit && VITE_PUBLIC_URL= pnpm build`
3. E2E는 `.env.test`가 있을 때만 `pnpm exec playwright install chromium`으로 브라우저를 준비한 뒤 `pnpm test`로 실행하고, 없으면 건너뛰었다고 적습니다.

## 결과

- 영역별로 통과/실패와 실행한 명령을 적습니다.
- 실패하면 첫 번째 실패 메시지를 그대로 옮기고, 고치기 전에는 통과했다고 말하지 않습니다.
