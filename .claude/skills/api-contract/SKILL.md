---
name: api-contract
description: backend/api-docs.yaml과 frontend/src/apis 호출부가 일치하는지 점검합니다. API를 추가·변경·삭제하거나 그런 PR을 리뷰할 때 사용합니다.
---

# API 계약 점검

계약의 기준은 `backend/api-docs.yaml`(OpenAPI)입니다.

## 절차

1. 변경 범위를 정합니다: `git diff <base>...HEAD --name-only`에서 `backend/api-docs.yaml`, 백엔드 컨트롤러·DTO, `frontend/src/apis/`, `frontend/src/interface/` 변경을 찾습니다.
2. 바뀐 엔드포인트마다 `api-docs.yaml`의 경로, HTTP 메서드, 요청 파라미터·본문, 응답 스키마를 읽습니다.
3. `frontend/src/apis/`에서 그 경로를 호출하는 함수를 찾고(`grep -rn '<경로 일부>' frontend/src/apis`), 메서드·파라미터 이름·요청 본문 필드가 맞는지 확인합니다.
4. 응답을 받는 타입(`frontend/src/interface/`)의 필드 이름과 nullable 여부가 스키마와 맞는지 확인합니다.
5. 백엔드 컨트롤러가 바뀌었는데 `api-docs.yaml`이 그대로면 문서 갱신 누락으로 봅니다.

## 결과

- 불일치를 `엔드포인트 — 백엔드 기준 / 프런트엔드 현재 / 고칠 곳` 형식으로 나열합니다.
- 불일치가 없으면 "API 계약 불일치 없음"과 확인한 엔드포인트 목록만 적습니다.
