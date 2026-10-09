# my-first-godot

Godot 4와 GDScript로 2D 웹게임을 직접 만들며 게임 개발 개념을 배우는 개인 학습 프로젝트다. 웹게임 개발을 목표로 Compatibility Renderer를 선택했다. Godot 프로젝트 설정의 이름은 `myFirstGodot`이다.

## 학습 방식

- 직접 코드를 작성하고 구조를 이해한다.
- AI가 전체 기능이나 코드를 대신 작성하지 않는다.
- 필요한 개념을 그때그때 배우며, 구현 전에 개념과 이유를 이해한다.
- 시행착오와 해결 과정도 기록한다.

## 현재 상태

Player Scene을 두 번 인스턴스화한 테스트 공간이다. 조작 가능한 Player는 WASD와 방향키로 이동하며 벽과 충돌한다. Floating 모드, 카메라 추적·스무딩·Limit, 사방 물리 경계를 사용한다.

## 문서 인덱스

- [Scene과 Node](docs/01-scene-and-node.md)
- [GDScript 기초](docs/02-gdscript-basics.md)
- [캐릭터 이동](docs/03-character-movement.md)
- [충돌](docs/04-collision.md)
- [Scene과 Instance](docs/05-scene-and-instance.md)
- [Input Map](docs/06-input-map.md)
- [Camera2D](docs/07-camera2d.md)
- [Resource](docs/08-resource.md)
- [TileMapLayer와 TileSet](docs/09-tilemap-and-tileset.md)
- [Area2D와 Signal](docs/10-area2d-and-signals.md)
- [기본 UI](docs/11-basic-ui.md)
- [Enemy 추적 이동](docs/12-enemy-chasing.md)
- [2026-10-06 — Day 1 기록](devlog/2026-10-06.md)
- [2026-10-07 — Day 2 기록](devlog/2026-10-07.md)
- [2026-10-08 — Day 3 기록](devlog/2026-10-08.md)
- [2026-10-09 — Day 4 기록](devlog/2026-10-09.md)
- [Codex 작업 지침](AGENTS.md)

## 타일 맵 학습 진행

TileMapLayer / TileSet의 기본 구조와 타일별 충돌 정의·반복 배치를 실습했다. 현재는 `icon.svg`를 사용하는 학습용 맵이다.
