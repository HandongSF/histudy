# AGENTS

HIStudy 웹 클라이언트의 탐색 레이어입니다. 저장소 공통 규칙은 루트 `AGENTS.md`를 따릅니다.

## 기준 파일

- `README.md`: 사람 중심의 설치, 실행, 환경 변수 안내
- `../backend/api-docs.yaml`: 백엔드 HTTP 계약
- `playwright.config.ts`: E2E 테스트 설정 (`setup` 프로젝트에서 권한별 인증 상태를 만든 뒤 `chromium` 프로젝트가 실행)

## 문맥 지도

- `src/apis/`: 백엔드 API 호출 모듈 (도메인별 파일)
- `src/pages/`: 라우트 단위 페이지 (`Admin`, `Report*`, `StudyApplication` 등)
- `src/components/`: 공용 UI 컴포넌트
- `src/store/`: 전역 상태
- `src/hooks/`, `src/utils/`, `src/lib/`, `src/const/`, `src/interface/`: 훅, 유틸리티, 상수, 타입
- `tests/`: Playwright E2E 테스트. 인증 헬퍼는 `tests/support/`, 인증 셋업은 `tests/*.setup.ts`

## 작업 규칙

- import 경로 별칭 `@/`는 `src/`를 가리킵니다.
- 백엔드 응답 형식에 의존하는 변경은 `../backend/api-docs.yaml`과 대조합니다.
- `.env`, `.env.test`는 커밋하지 않습니다. 필요한 키는 `.env.test.example`과 `README.md`를 참고합니다.

## 빠른 명령어

- pnpm 준비: `corepack enable` (`package.json`의 `packageManager`로 pnpm 8.15.9 사용. pnpm 9 이상은 lockfile을 거부함)
- 의존성 설치: `pnpm install --frozen-lockfile`
- 개발 서버: `pnpm start` (`http://localhost:3000`)
- 타입 체크: `pnpm exec tsc --noEmit`
- 빌드: `pnpm build` (`VITE_PUBLIC_URL`이 정의되어 있어야 함. 루트 서빙이면 빈 값: `VITE_PUBLIC_URL= pnpm build`)
- E2E 테스트: `pnpm test` (`.env.test` 필요)
