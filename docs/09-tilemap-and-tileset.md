# TileMapLayer와 TileSet

## 정의와 배치를 나누는 이유

반복되는 벽을 하나씩 Node로 구성하면 같은 설정을 여러 번 해야 한다. 타일 방식은 타일의 성질을 한 번 정의하고 필요한 위치에 반복 배치한다.

| 구성 요소 | 역할 | 현재 프로젝트 |
| --- | --- | --- |
| TileSet | 어떤 타일이 있고 각 타일이 어떤 성질을 갖는지 정의하는 Resource | 이미지 영역과 타일별 충돌 정의 |
| TileMapLayer | TileSet에 정의된 타일을 맵의 어느 칸에 배치할지 관리하는 Node | `main.tscn`에 추가한 타일 배치 |

핵심은 **TileSet에서 정의하고, TileMapLayer에서 배치한다**는 것이다. 현재 TileSet은 별도 파일이 아니라 `main.tscn` 내부 Resource로 저장되어 있다.

## Tile Size와 Atlas Source

Tile Size는 맵에서 사용하는 타일 칸의 기본 크기다. 이번에는 구조를 이해하기 위해 `64 × 64`로 설정했다.

Atlas Source는 텍스처에서 타일로 사용할 영역을 정의하는 소스다. 기존 `icon.svg`를 텍스처로 등록하고, 텍스처 영역도 `64 × 64` 단위로 나누었다. Tile Size와 Atlas의 텍스처 영역 크기는 역할이 다르지만 이번 실습에서는 같은 값으로 설정했다.

현재 Atlas에는 `(0, 0)`, `(1, 0)`, `(0, 1)`, `(1, 1)`의 네 타일이 정의되어 있다. 이 좌표는 텍스처 안의 타일 위치이며, 맵에 배치할 칸의 좌표와는 다르다. TileSet 편집에서 타일을 정의한 뒤 TileMapLayer에서 선택하여 여러 칸에 배치했다.

## Physics Layer와 타일별 Collision

타일 이미지가 보인다고 충돌이 자동으로 생기지는 않는다. TileSet에 Physics Layer를 추가하고 타일별로 충돌 모양을 지정해야 한다.

이번 실습에서는 Physics Layer 0을 추가한 뒤 TileSet 편집의 **물리 → Physics Layer 0**에서 선택한 타일에 F 키로 전체 영역을 덮는 사각형 Collision을 만들었다. F 키 사용 과정은 사용자의 실습 기록이다.

현재 파일에서는 Atlas 좌표 `(1, 0)`의 타일에만 충돌 다각형이 저장되어 있다. 꼭짓점은 타일 중심 기준 `(-32, -32)`, `(32, -32)`, `(32, 32)`, `(-32, 32)`로, 64×64 영역을 덮는다. 나머지 세 타일에는 충돌 다각형이 정의되어 있지 않다.

| 타일 상태 | 실습에서 확인한 결과 |
| --- | --- |
| 이미지가 있고 Collision 정보가 없음 | 화면에 보이지만 Player가 통과함 |
| 이미지와 Collision 정보가 있음 | 화면에 보이며 Player가 막힘 |

플레이 결과는 사용자가 직접 확인한 내용이다. 보이는 영역과 충돌 영역의 기본 차이는 [충돌 문서](04-collision.md)와 같다.

## 충돌 정의의 재사용

Collision을 가진 타일을 TileMapLayer의 여러 칸에 배치했다. 각 칸에 StaticBody2D나 CollisionShape2D Node를 직접 추가하지 않아도 동일한 타일의 충돌 정의가 적용된다.

```text
TileSet에서 벽 타일의 Collision을 한 번 정의
→ TileMapLayer에서 그 타일을 여러 위치에 배치
→ 각 배치가 동일한 충돌 성질을 사용
```

| 방식 | 직접 설정하는 단위 |
| --- | --- |
| 기존 벽 | StaticBody2D와 CollisionShape2D를 벽마다 구성하고 배치 |
| 타일 맵 | TileSet에서 타일의 성질을 정의하고 TileMapLayer에서 반복 배치 |

현재는 타일 배치와 기존 StaticBody2D 사방 경계를 함께 사용한다. 기존 경계를 타일로 모두 교체한 상태는 아니다.

관련 문서: [Resource](08-resource.md), [Day 2 기록](../devlog/2026-10-07.md).
