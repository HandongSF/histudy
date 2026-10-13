# 저장소 이전 기록

2026-10-13에 `HandongSF/histudy-be`와 `HandongSF/histudy-fe`를 이 저장소로 통합했습니다.

## 원본

| 원본 | 기준 | 위치 | 태그 |
|---|---|---|---|
| [HandongSF/histudy-be](https://github.com/HandongSF/histudy-be) | `main` @ `bbb05c8` | `backend/` | `vX.Y.Z` → `be-vX.Y.Z` |
| [HandongSF/histudy-fe](https://github.com/HandongSF/histudy-fe) | `main` @ `bb6307e` | `frontend/` | `vX.Y.Z` → `fe-vX.Y.Z` |

`main` 이외의 브랜치는 원본 저장소에 남아 있습니다.

## 방식

각 원본의 `main`을 [git-filter-repo](https://github.com/newren/git-filter-repo)로 재작성한 뒤 `--allow-unrelated-histories`로 병합했습니다.

```bash
# histudy-fe는 frontend, fe-, histudy-fe로 바꿔 같은 방식으로 실행
git filter-repo --to-subdirectory-filter backend --tag-rename '':'be-' \
  --message-callback "
import re
return re.sub(rb'(?<![\w/#&])#(\d{1,4})(?![\w/])', rb'HandongSF/histudy-be#\1', message)
"
```

- 모든 커밋의 경로를 `backend/`, `frontend/` 아래로 옮겼습니다. 작성자, 커미터, 날짜는 그대로입니다.
- 커밋 메시지의 이슈와 PR 참조(`#123`)를 원본 저장소 참조(`HandongSF/histudy-be#123`)로 바꿨습니다. `feature/#12` 같은 브랜치 이름 안의 번호는 바꾸지 않았습니다.
- 재작성으로 커밋 해시가 모두 바뀌었습니다.
- 태그만 옮겼고 GitHub Release와 릴리스 노트는 옮기지 않았습니다. 원본 저장소의 Releases를 참고하세요.

## 통합 후 바뀐 점

- 워크플로를 루트 `.github/workflows/`로 옮기고, 배포는 프런트엔드를 백엔드에 포함하는 단일 이미지 방식(`deploy-dev.yml`)으로 합쳤습니다. 기존 `deploy-prod.yml`(be), `sshdeploy.yml`(fe)은 쓰지 않아 삭제했습니다. 자세한 내용은 [../deploy.md](../deploy.md)를 참고하세요.
- `Dockerfile`, `docker-compose.yml`, `.dockerignore`를 `backend/`에서 루트로 옮겼습니다.
- 프런트엔드의 pre-commit hook(simple-git-hooks, pretty-quick)을 제거했습니다.

## 원본 커밋 찾기

`histudy-be.commit-map`, `histudy-fe.commit-map`은 `원본 해시 새 해시` 형식의 대응표입니다.

```bash
grep '^bbb05c8' docs/migration/histudy-be.commit-map   # 원본 → 새 해시
grep ' 0216c24' docs/migration/histudy-be.commit-map   # 새 해시 → 원본
```
