# HIStudy

HIStudy는 한동대학교 온라인 스터디그룹 관리 서비스입니다. 학생들은 희망하는 과목의 우선순위에 따라 스터디그룹에 배정되며, 배정된 스터디그룹에서 스터디 활동을 기록하고 인증할 수 있습니다. 2023년 1학기 소프트웨어공학 수업 팀 프로젝트로 시작하여, 2023년 2학기부터 전산전자공학부 학생들을 대상으로 서비스를 제공하고 있습니다.

## 구성

| 디렉토리 | 설명 | 시작하기 |
|---|---|---|
| [`backend/`](backend) | API 서버 (Spring Boot, Java 17) | [backend/README.md](backend/README.md) |
| [`frontend/`](frontend) | 웹 클라이언트 (React, Vite) | [frontend/README.md](frontend/README.md) |

배포 시에는 프런트엔드 빌드 결과를 백엔드에 포함해 하나의 이미지로 빌드합니다. 자세한 내용은 [docs/deploy.md](docs/deploy.md)를 참고하세요.

## 이전 저장소

이 저장소는 아래 두 저장소를 커밋 히스토리와 함께 통합한 것입니다. 기존 저장소는 보관(archive) 대상이며, 과거 이슈, PR, 릴리스 노트는 해당 저장소에서 확인할 수 있습니다.

- [HandongSF/histudy-be](https://github.com/HandongSF/histudy-be) → `backend/`
- [HandongSF/histudy-fe](https://github.com/HandongSF/histudy-fe) → `frontend/`

이전 방식과 원본 커밋 해시 대응표는 [docs/migration](docs/migration)을 참고하세요.

## Contributing

- 새로운 기능이나 개선사항을 제안하려면 GitHub Issue를 작성해주세요.
- 또는 이 저장소를 fork 하고 Pull Request를 보내서 기여할 수 있습니다. 단, 작업규모가 크다고 판단되는 경우에는 먼저 Issue를 작성해주세요.

## License

HIStudy는 Apache License 2.0을 따릅니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.
