---
name: pr
description: 현재 브랜치로 HIStudy PR을 만듭니다. PR 템플릿을 채우고 제목은 커밋 규칙을 따릅니다. PR을 올리거나 PR 본문을 쓸 때 사용합니다.
---

# PR 생성

기준 브랜치는 따로 지정이 없으면 `main`입니다.

## 1. 전제 점검

다음 중 하나라도 어긋나면 멈추고 알립니다.

- 현재 브랜치가 기준 브랜치가 아닙니다.
- 커밋하지 않은 변경이 없습니다(`git status --short`).
- 기준 브랜치보다 앞선 커밋이 있습니다(`git log origin/<base>..HEAD`).
- 이 브랜치로 열린 PR이 없습니다(`gh pr list --head <branch>`).

## 2. 제목

- `commit` 스킬과 같은 형식: `<type>[(scope)]: <한국어 설명>`.
- 커밋이 하나면 그 메시지를 그대로 씁니다.
- 여러 개면 전체를 대표하는 한 줄로 씁니다. 저장소가 squash 머지에서 PR 제목을 커밋 메시지로 쓰므로 반드시 규칙을 지킵니다.

## 3. 본문

`.github/PULL_REQUEST_TEMPLATE.md`의 두 섹션을 한국어로 채웁니다. 섹션을 지우거나 새로 만들지 않습니다.

- **작업 사항**: 영역별로 무엇을 왜 바꿨는지 짧게 씁니다.
- **관련 이슈**: `close #N` 형식. 없으면 "없음".

넣지 않는 것: 검증 결과(CI가 같은 검사를 돌립니다), Claude 작성 표시나 "Generated with" 줄.

## 4. 영역 간 계약

`backend/api-docs.yaml`이나 `frontend/src/apis/` 중 한쪽만 바뀌었으면 `api-contract` 스킬로 확인하고, 상대편 수정이 필요한데 빠졌다면 작업 사항에 적습니다.

## 5. 푸시와 생성

1. PR 대상 저장소를 가리키는 원격으로 푸시합니다: `git push -u <remote> HEAD`. 원격이 여럿이면(`origin`이 포크인 경우 등) `git remote -v`로 확인합니다.
2. 원격과 갈라졌으면 멈추고 물어봅니다. 자동 rebase나 force push는 하지 않습니다.
3. `gh pr create --base <base> --title "<제목>" --body "<본문>"`으로 만들고(초안이면 `--draft`), PR 번호와 URL을 알립니다.
