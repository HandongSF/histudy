# 배포

프런트엔드와 백엔드는 하나의 산출물로 배포합니다. 루트 `Dockerfile`이 다음 순서로 이미지를 만듭니다.

1. `frontend/`를 빌드합니다 (`pnpm build`, Node 24, pnpm 8).
2. 빌드 결과 `dist/`와 `backend/api-docs.yaml`을 백엔드의 `src/main/resources/static/`에 넣고 `bootJar`를 빌드합니다.
3. jar만 JRE 이미지로 복사합니다. Spring Boot가 `classpath:static`의 정적 파일을 서빙하고, `WebController`가 클라이언트 라우트를 `index.html`로 돌려줍니다.

`src/main/resources/static/`은 빌드 중에만 채워지며 git에는 올리지 않습니다.

## 빌드 인자

Vite가 빌드 시점에 번들에 넣는 값입니다. 브라우저에 그대로 노출되므로 비밀 값을 넣지 않습니다.

| 이름 | 필수 | 설명 |
|---|---|---|
| `VITE_PUBLIC_URL` | | 정적 자원 기준 경로. 통합 이미지는 루트(`/`)에서 서빙하므로 **빈 값**을 씁니다(기본값). `http://...` 같은 URL을 넣으면 자원 경로가 깨집니다 |
| `VITE_BACK_BASE_URL` | | 백엔드 API 기준 URL. 통합 이미지는 같은 출처에서 API를 서빙하므로 **빈 값**(상대 경로 `/api/...`)을 씁니다. `http://localhost:8080`은 사용자 브라우저의 localhost를 가리키므로 원격 접속에서 실패합니다 |
| `VITE_BACK_FILE_BASE_URL` | | 업로드 파일 기준 URL |
| `VITE_CLOUD_FRONT_BASE_URL` | | CDN 기준 URL |
| `VITE_CLIENT_ID` | | Google 로그인 클라이언트 ID |

`docker-compose.yml`은 같은 이름의 환경 변수를 빌드 인자로 넘깁니다.

## 개발 서버 (자동)

`main`에 push되면 `ci.yml`이 검사를 마친 뒤 `deploy-dev.yml`을 호출해, self-hosted runner(`[self-hosted, HIStudy, dev]`)에서 다음을 실행합니다.

1. `docker compose build`로 이미지를 빌드합니다. 실패하면 실행 중인 컨테이너는 그대로 둡니다.
2. `docker compose up -d --no-build`로 컨테이너를 교체합니다.
3. `histudy-be:sha-*` 이미지 중 방금 배포한 것과 최근 2개만 남기고 지웁니다. 다른 태그와 다른 서비스 이미지는 건드리지 않습니다.

롤백은 남아 있는 이미지로 `IMAGE_TAG=sha-<커밋> docker compose up -d --no-build`를 실행합니다.

- `backend/`, `frontend/` 또는 공통 빌드 파일(`Dockerfile`, `docker-compose.yml`, `.dockerignore`, `ci.yml`, `deploy-dev.yml`)이 바뀐 경우에만 배포합니다. 문서만 바뀐 커밋은 배포하지 않습니다.
- 검사 잡이 하나라도 실패하면 배포하지 않습니다.
- Actions 탭에서 `Deploy Dev`를 수동 실행(`workflow_dispatch`)할 수도 있습니다.

새 저장소에서 처음 켤 때 필요한 설정:

| 종류 | 이름 | 비고 |
|---|---|---|
| Environment `dev` variables | `VITE_CLIENT_ID`, `VITE_BACK_FILE_BASE_URL`(이미지 경로를 쓰는 경우) | `VITE_PUBLIC_URL`, `VITE_BACK_BASE_URL`은 빈 값이어야 하므로 워크플로가 넘기지 않습니다 |
| Variables (선택) | `DEPLOY_HOST_PORT`, `DEPLOY_ACTIVE_PROFILE`, `DEPLOY_CONFIG_PATH`, `DEPLOY_IMAGE_NAME`, `DEPLOY_COMPOSE_PROJECT_NAME` | 기본값은 워크플로 참고 |
| Self-hosted runner | 라벨 `HIStudy`, `dev` | 기존 `histudy-be` 저장소의 runner를 이 저장소(또는 조직)로 다시 등록 |

Compose 프로젝트 이름은 기본값 `histudy-be`로 고정되어 있어, 기존 저장소에서 만든 컨테이너와 볼륨(`histudy-be_webapp_images` 등)을 그대로 사용합니다.

## 운영 서버 (수동)

운영 서버는 온프레미스이며 워크플로로 배포하지 않습니다. 개발 서버와 같은 이미지를 운영 서버에서 빌드합니다.

```bash
git clone https://github.com/HandongSF/histudy.git && cd histudy
git checkout <배포할 태그 또는 커밋>

export COMPOSE_PROJECT_NAME=histudy-be
export ACTIVE_PROFILE=prod CONFIG_PATH=/etc/histudy-be/ IMAGE_TAG=<태그>
export VITE_CLIENT_ID=...   # 운영 값. VITE_PUBLIC_URL, VITE_BACK_BASE_URL은 비워 둠
docker compose up -d --build
```

이미지 없이 jar만 필요하면 빌드 단계까지만 실행해 꺼냅니다.

```bash
docker build --target builder --build-arg VITE_CLIENT_ID=... -t histudy-builder .
docker create --name histudy-jar histudy-builder
docker cp histudy-jar:/project/build/libs/. ./out/ && docker rm histudy-jar
```

## CI

`.github/workflows/ci.yml`은 변경된 영역만 검사합니다.

| 잡 | 실행 조건 | 내용 |
|---|---|---|
| `Detect changes` | 항상 | `backend/`, `frontend/` 변경 여부 판단. `Dockerfile` 등 공통 빌드 파일이 바뀌면 둘 다 검사 |
| `Backend test` | 백엔드 변경 | `./gradlew clean test` |
| `Frontend build` | 프런트엔드 변경 | 타입 체크와 빌드 |
| `Frontend E2E` | 프런트엔드 변경 + `E2E_ENABLED=true` | Playwright. secrets `NODE_ENV`, `VITE_BACK_BASE_URL`, `VITE_PUBLIC_URL` 필요 |
| `CI result` | 항상 | 위 잡 중 실패가 있으면 실패. 브랜치 보호의 필수 체크로 이 잡 하나만 지정합니다 |
| `Deploy dev` | `main` push + 영역 변경 + 검사 통과 | `deploy-dev.yml` 호출 (위 "개발 서버" 참고) |

워크플로를 고친 뒤에는 `actionlint`로 검사합니다. self-hosted runner 라벨은 `.github/actionlint.yaml`에 등록되어 있습니다.

## 로컬에서 프런트엔드 개발

통합 이미지는 배포 산출물만 바꿉니다. 로컬 개발 방식은 그대로입니다.

- `frontend/`에서 `pnpm start`(Vite, `http://localhost:3000`)로 띄우고, `VITE_BACK_BASE_URL`을 개발 서버 API로 지정해 호출합니다.
- 개발 서버는 `http://localhost:3000` 출처의 CORS 요청을 허용해야 합니다(서버의 `application-dev.yml`의 `custom.origin.allowed`). 이 설정은 이미지가 아니라 서버 설정 파일에 있으므로 통합 이미지로 바뀌어도 그대로입니다.
- 통합 이미지에서는 매핑되지 않은 경로(`/api/...` 포함)의 404 응답 본문이 비어 있지 않고 `index.html`입니다. 상태 코드는 404로 같고, 프런트엔드의 오류 처리(`src/utils/apiError.ts`)는 JSON이 아닌 본문을 무시하므로 화면 동작은 같습니다.
- 배포 결과와 같은 환경에서 확인하려면 루트에서 `docker compose up --build`로 통합 이미지를 띄웁니다. 이때는 같은 출처에서 서빙되므로 CORS가 필요 없습니다.
