---
name: commit
description: HIStudy 커밋 메시지 규칙(Conventional Commits 1.0.0, 헤더 한 줄, 한국어 설명)으로 커밋합니다. 커밋을 만들거나 커밋 메시지를 쓸 때 사용합니다.
---

# 커밋

[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)을 따릅니다.

## 형식

```
<type>[(scope)][!]: <설명>
```

- **type**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert` 중 하나.
- **scope**(선택): 변경 영역. `backend`, `frontend`, `ci`, `deploy`, `docs` 등.
- **!**: 호환성을 깨는 변경일 때만 붙입니다.
- **설명**: 한국어로, 무엇을 했는지 짧게 씁니다. 끝에 마침표를 찍지 않습니다.

## 규칙

- 헤더 한 줄만 씁니다. 본문과 푸터는 쓰지 않습니다.
- Claude나 AI를 저자로 언급하지 않습니다. `Co-Authored-By` 줄을 넣지 않습니다.
- 한 커밋에는 한 가지 목적의 변경만 담습니다. 목적이 둘이면 커밋을 나눕니다.

## 예시

```
feat(frontend): 스터디 신청 단계에 친구 검색 추가
fix(backend): 보고서 재시도 시 상태 보존
ci: Claude 코드리뷰 워크플로 추가
refactor(backend)!: 그룹 조회 API 응답 형식 변경
```
