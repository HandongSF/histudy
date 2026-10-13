# AGENTS

HIStudy 모노레포의 탐색 레이어입니다. 저장소 전반의 구조와 공통 규칙만 다루고, 각 영역의 세부 맥락은 하위 `AGENTS.md`를 따릅니다.

## 구조

| 경로 | 내용 | 영역 지침 |
|---|---|---|
| `backend/` | Spring Boot API 서버 (Java 17, Gradle) | `backend/AGENTS.md` |
| `frontend/` | React + Vite 웹 클라이언트 (TypeScript, pnpm 8) | `frontend/AGENTS.md` |
| `Dockerfile`, `docker-compose.yml` | 프런트엔드 빌드 결과를 백엔드 jar에 포함한 단일 이미지 빌드 | `docs/deploy.md` |
| `.github/workflows/` | `ci.yml`(검사, 영역이 바뀐 `main` push는 개발 서버 배포까지), `deploy-dev.yml`(배포 재사용 워크플로) | `docs/deploy.md` |
| `docs/` | 저장소 공통 문서: 배포(`deploy.md`), 저장소 이전 기록(`migration/`) | - |

## 영역 간 계약

- HTTP API 계약의 기준은 `backend/api-docs.yaml`입니다.
- API를 바꾸는 작업은 `backend/api-docs.yaml`과 `frontend/src/apis/`의 호출부를 같은 변경 단위에서 함께 확인합니다.
- 배포 산출물은 하나입니다. 프런트엔드 `dist/`가 백엔드 `src/main/resources/static/`에 들어가 Spring Boot가 함께 서빙하므로, 경로나 라우팅을 바꿀 때는 양쪽 영향을 확인합니다.

## 작업 규칙

- 영역별 명령은 해당 영역 디렉토리에서 실행합니다. 루트의 빌드 파일은 배포 이미지용입니다.
- 한 영역 안에서 끝나는 변경은 그 영역 디렉토리 밖을 건드리지 않습니다.
- CI는 변경된 영역만 검사합니다. 새 검사 잡을 추가할 때는 `ci.yml`의 `changes` 출력으로 조건을 걸고 `result` 잡의 `needs`에 추가합니다.

## 빠른 명령어

- 백엔드 테스트: `cd backend && ./gradlew clean test`
- 프런트엔드 타입 체크와 빌드: `cd frontend && pnpm exec tsc --noEmit && pnpm build`
- 프런트엔드 E2E: `cd frontend && pnpm test` (`.env.test` 필요)
- 배포 이미지 빌드: `docker compose build` (루트에서 실행. 빌드 인자는 `docs/deploy.md` 참고)

## 히스토리

- 기존 두 저장소의 `main` 히스토리를 경로만 `backend/`, `frontend/` 아래로 옮겨 보존했습니다. `git log -- backend/<path>`, `git blame`이 통합 전의 커밋까지 추적됩니다.
- 통합 전 커밋 메시지의 이슈와 PR 번호는 `HandongSF/histudy-be#N`, `HandongSF/histudy-fe#N` 형식으로 원본 저장소를 가리킵니다.
- 원본 커밋 해시를 찾으려면 `docs/migration/`의 commit-map을 참고합니다.
