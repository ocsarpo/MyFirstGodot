# Enemy 추적 이동

## 입력 대신 게임 로직으로 움직이기

CharacterBody2D는 키보드로 조작하는 Player에만 쓰는 Node가 아니다. 방향과 속도를 게임 로직으로 계산해도 같은 이동·충돌 기능을 사용할 수 있다.

현재 `enemy.tscn`의 구성은 다음과 같다.

```text
Enemy (CharacterBody2D, enemy.gd)
├─ Sprite2D          icon.svg
└─ CollisionShape2D RectangleShape2D
```

Enemy의 Shape 크기는 116×122다. Main에는 Enemy Instance 하나가 `(-483, 20)`에 배치되어 있고, 이 Instance의 Motion Mode는 Floating이다. 원본 `enemy.tscn`에는 Floating 설정이 따로 저장되어 있지 않다.

## Script 연결과 Target 참조

`.gd` 파일을 만드는 것과 Node의 Script 속성에 연결하는 것은 별개다. `@export` 변수는 해당 스크립트가 Node에 연결되어야 Inspector에 나타난다.

```gdscript
@export var target: Node2D
@export var stop_distance: float = 0.0
var speed: float = 100.0
```

`target`은 추적할 Node의 참조다. Main에서 Enemy의 Inspector로 조작 가능한 Player를 지정했으며, 파일에는 `target = NodePath("../Player")`로 저장되어 있다. 대상을 찾는 코드를 Enemy 내부에 고정하지 않고 Instance별로 지정할 수 있다.

`stop_distance`는 Enemy가 Target에 얼마나 가까워지면 멈출지 정하는 값이다. `@export`로 Inspector에 노출하여 코드 파일을 수정하지 않고 Scene Instance별로 조절할 수 있다. 현재 충돌 기반 Game Over를 확인하기 위해 코드 기본값이 `0.0`으로 변경되었고, `main.tscn`의 기존 `300.0` 재설정은 제거되어 기본값을 사용한다. `speed`는 일반 변수로 유지한다.

## 월드 위치로 방향과 거리 계산

- `position`: 부모 기준 로컬 위치다.
- `global_position`: 월드 기준 위치다. 서로 다른 객체의 위치를 같은 기준으로 비교할 때 사용한다.
- `direction_to()`: 현재 위치에서 목표 위치로 향하는 단위 방향 벡터를 구한다. 두 위치가 같으면 0 벡터다.
- `distance_to()`: 두 위치 사이의 거리를 구한다.

목표가 오른쪽이면 방향은 대략 `(1, 0)`, 위쪽이면 `(0, -1)`이다. 이번에는 Enemy와 Target의 `global_position`으로 계산했다.

## 현재 추적 코드의 이동 부분

```gdscript
func _physics_process(delta: float) -> void:
    if target == null:
        return

    var distance = global_position.distance_to(target.global_position)
    if distance <= stop_distance:
        velocity = Vector2.ZERO
        return

    var direction = global_position.direction_to(target.global_position)
    velocity = direction * speed
    move_and_slide()
```

Target을 지정하지 않았으면 해당 물리 프레임의 처리를 끝낸다. Target이 있으면 매 물리 프레임마다 거리를 확인하고, 충분히 멀 때 방향을 다시 계산해 이동한다.

`velocity`는 속도 벡터이며 `move_and_slide()`가 이동과 충돌을 처리한다. 이 함수가 시간 간격을 반영하므로 `delta`를 속도에 다시 곱하지 않는다. 기본 이동 원리는 [캐릭터 이동](03-character-movement.md)과 같다.

설정된 `stop_distance` 이내에서는 속도를 0으로 만들고 반환하므로 그 프레임에는 `move_and_slide()`를 호출하지 않는다. Player가 다시 멀어지면 다음 물리 프레임부터 추적을 재개한다.

## 중심 거리와 충돌 모양

`distance_to()`는 Node 원점 간 거리다. 이번에는 캐릭터 중심 간 거리로 사용했지만, CollisionShape 경계 사이의 실제 간격을 계산하는 함수는 아니다. Shape의 크기와 위치가 별도로 존재하므로 중심이 떨어져 있어도 충돌 영역은 맞닿을 수 있다.

사용자는 정지 거리를 100으로 테스트했을 때 Enemy가 충돌 후에도 밀어붙이는 느낌을 확인했다. 120으로 조정하니 충돌 전에 자연스럽게 멈췄다. 원하는 중심 거리는 이동 방향에 따른 두 충돌 영역의 크기와 여유 거리의 영향을 받는다.

## 숫자를 조절하는 기준

데이터에서 계산해야 하는 값과 게임 느낌을 위해 조절하는 디자인 파라미터는 구분할 수 있다. 현재 `stop_distance`는 자동 계산값이 아니라 Inspector에서 튜닝하는 게임 디자인 값으로 취급한다. 의미 있는 이름을 붙이고 조절 가능하게 노출했으며, 적절한 값은 충돌 모양과 원하는 게임 느낌에 따라 다시 검토한다.

CollisionShape 크기를 반영하는 자동 계산과 Area2D 기반 Enemy 감지 영역은 아직 구현하지 않았다.

## 충돌에서 패배 조건으로 연결

현재 Enemy는 `move_and_slide()` 다음에 slide collision을 순회하고, player 그룹인 충돌 대상의 `die()`를 호출한다. 충돌 정보를 읽는 코드는 [충돌 문서](04-collision.md)에 정리했다.

Player는 사망 상태를 기록하고 이동을 중단한 뒤 `died` Signal을 보낸다. Main은 기존 점수 Label을 GAME OVER로 바꾼다. 실제로 부딪히기 전에 멈추면 이 흐름을 확인할 수 없으므로 이번에는 정지 거리를 0으로 두었다.

현재 학습한 동작은 목표 방향으로 이동하고 일정 거리에서 멈추는 추적이다. 관련 경험은 [Day 4 기록](../devlog/2026-10-09.md), Inspector 노출은 [Day 5 기록](../devlog/2026-10-12.md)에 정리했다.
