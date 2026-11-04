---
name: review
description: HIStudy 전용 코드리뷰 기준. 일반 리뷰(code-review 플러그인)가 다루지 않는 모노레포 계약과 CI 배선을 확인할 때 사용합니다.
---

# HIStudy 리뷰 기준

일반적인 버그·보안·품질 리뷰는 code-review 플러그인과 `AGENTS.md`가 담당합니다. 이 스킬은 그 위에 HIStudy 전용 항목만 더합니다.

## 확인 항목

1. **API 계약**: `backend/api-docs.yaml`이나 백엔드 컨트롤러가 바뀌었으면 `frontend/src/apis/` 호출부가 같은 PR에서 맞춰졌는지 확인합니다. 자세한 절차는 `api-contract` 스킬을 따릅니다.
2. **단일 배포 산출물**: 프런트엔드 라우트, `VITE_PUBLIC_URL`, 정적 경로가 바뀌면 백엔드 `src/main/resources/static/` 서빙과 Spring Security 경로 허용에 영향이 없는지 봅니다.
3. **CI 배선**: `ci.yml`에 검사 잡을 추가했다면 `changes` 출력으로 조건을 걸었는지, `result` 잡의 `needs`에 넣었는지 확인합니다.
4. **영역 경계**: 한 영역 안에서 끝나는 변경이 다른 영역이나 루트 파일을 건드리지 않았는지 봅니다.
5. **시크릿**: 워크플로나 설정 파일에 시크릿 값이 평문으로 들어가지 않았는지, `pull_request_target` 잡이 포크 코드를 체크아웃하지 않는지 확인합니다.

## 보고

- 위 항목에서 실제 문제가 있을 때만 지적합니다. 해당 없는 항목은 언급하지 않습니다.
- 지적은 파일과 줄을 짚고, 무엇이 왜 깨지는지 한 문장으로 씁니다.
