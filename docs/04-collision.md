# 충돌

## 보이는 것과 물리 영역

`Sprite2D`나 `Polygon2D`는 외형을 표시한다. 화면에 보이는 것만으로 충돌이 생기지는 않는다.

`CollisionShape2D`는 부모 물리 객체의 충돌 모양을 제공한다. 실제 모양은 `RectangleShape2D` 같은 Shape Resource에 담긴다. 현재 Player와 벽 모두 사각형 Shape를 사용한다. 외형과 충돌 영역의 위치·크기는 별도로 설정한다.

- `CharacterBody2D`: 코드로 움직이고 충돌을 처리하는 캐릭터의 본체다.
- `StaticBody2D`: 벽·바닥·건물처럼 움직이지 않는 물리 객체에 적합하다.

현재 벽 구조는 다음과 같다.

```text
StaticBody2D
├─ Polygon2D
└─ CollisionShape2D
```

## 사방 경계의 현재 구성

`main.tscn`에는 사방 경계를 위한 StaticBody2D 네 개가 있다. 위치 기준으로 확인한 실제 이름은 다음과 같다.

| 방향 | 실제 Node 이름 |
| --- | --- |
| 오른쪽 | `StaticBody2D` |
| 위쪽 | `StaticBody2D2` |
| 왼쪽 | `StaticBody2D3` |
| 아래쪽 | `StaticBody2D4` |

`LeftWall`, `RightWall`, `TopWall`, `BottomWall`은 역할을 설명하는 이름이며 현재 파일에 저장된 이름은 아니다. 각 벽은 서로 다른 RectangleShape2D Resource를 참조한다.

충돌 영역을 점검할 때는 에디터의 **Debug → Visible Collision Shapes**를 켜고 실행하면 된다. 외형과 물리 모양이 맞는지 확인하는 데 유용하다.

## 카메라와의 차이

Camera Limit은 카메라가 보여줄 영역을 제한한다. Collision은 Player가 이동할 수 있는 영역을 제한한다. 카메라 Limit만으로는 Player가 월드 밖으로 나가는 것을 막을 수 없다.

관련 문서: [Camera2D](07-camera2d.md), [Resource 공유](08-resource.md).
