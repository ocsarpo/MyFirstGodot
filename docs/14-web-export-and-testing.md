# Web Export와 실제 기기 테스트

## 현재 Export 설정

`export_presets.cfg`에 실행 가능한 Web preset을 추가했다. Export preset은 출력 대상과 옵션을 저장하고, Export Template은 빌드에 필요한 엔진 실행 템플릿이다. 사용자는 템플릿을 설치해 경고를 해소한 뒤 Web 실행을 확인했다. 템플릿 설치 자체는 저장소 파일이 아닌 로컬 환경 작업이다.

- 출력 경로: `build/web/index.html`
- Desktop / Mobile VRAM Texture Compression: 모두 활성화
- Thread Support: 비활성화
- 프로젝트 텍스처 import: `textures/vram_compression/import_etc2_astc = true`

로컬에 HTML·JavaScript·WASM·PCK 등의 산출물이 있다. 재생성 가능한 `build/web/`는 로컬에 보존하되 Git에서 제외하며, preset과 프로젝트 소스를 커밋한다.

## One-click Deploy와 로컬 네트워크 테스트

사용자는 Godot의 One-click Deploy로 로컬 서버에서 Web build를 실행했다. PC 브라우저에서 로딩, START, 키보드·조이스틱 이동, 획득, GAME OVER, RESTART를 확인했다.

다른 기기 접속을 위해 Editor Settings의 Web HTTP Host를 `0.0.0.0`으로 설정하고 TLS를 사용했다고 기록했다. `0.0.0.0`은 서버가 로컬 네트워크 인터페이스들에서 연결을 받게 하는 바인딩 주소다. 휴대폰에는 이 주소 대신 같은 네트워크 PC의 LAN IPv4 주소로 접속한다.

```text
https://<PC IPv4>:8060/tmp_js_export.html
```

이 URL은 로컬 테스트용이며 공개 배포 URL이 아니다. Host·TLS·포트와 실행 성공은 사용자가 제공한 테스트 기록이며 프로젝트 설정 파일만으로 확인한 값은 아니다.

## 모바일 테스트와 남은 확인

사용자는 PC에서 LAN IP 접속과 모바일 Chrome 실행·터치 조작을 확인했다. Safari는 self-signed TLS와 로컬 IP 테스트 환경에서 접속 문제가 있었다. 이것을 Safari의 게임 미지원으로 판단하지 않으며, 정상 HTTPS로 배포한 뒤 다시 확인해야 한다.

휴대폰에서는 PC와 화면 크기·비율이 달라 월드와 UI 가독성을 따로 조절했다. Camera Zoom 기본값 1.0, 1280×720 기준 `canvas_items` / `keep`, 조이스틱·버튼·글꼴 확대를 적용했다. 설정은 [Camera2D](07-camera2d.md), [기본 UI](11-basic-ui.md)를 참고한다.

현재는 로컬 PC·모바일 Web 테스트까지 진행했다. itch.io 공개 배포와 배포 환경 Safari 검증은 아직 하지 않았다.
