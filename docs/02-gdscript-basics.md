# GDScript 기초

## 스크립트의 기본 구성

현재 Player 스크립트는 `gdscript.gd`다.

```gdscript
extends CharacterBody2D

@export var controllable: bool = true
var speed = 200.0
```

- `extends`: 스크립트가 어떤 클래스를 기반으로 하는지 정한다. 여기서는 CharacterBody2D의 `velocity`, `move_and_slide()` 등을 사용한다.
- `var`: 값을 저장하는 변수를 선언한다.
- `: bool`: 변수의 타입을 명시한다. 현재 `speed`에는 타입 표기를 따로 쓰지 않았다.
- `@export`: 변수를 Inspector에 노출하여 인스턴스별로 설정할 수 있게 한다.
- `func`: 함수를 정의한다. 인자에 `delta: float`처럼 타입을 쓸 수 있고, `-> void`는 반환값이 없음을 뜻한다.

## Godot가 호출하는 함수

| 함수 | 용도 |
| --- | --- |
| `_ready()` | Node와 자식들이 Scene Tree에서 준비되었을 때 초기 설정을 수행한다. 일반적인 생성 과정에서는 한 번 호출된다. |
| `_process(delta)` | 렌더링 프레임마다 실행된다. 초기 Sprite2D 이동에 사용했다. |
| `_physics_process(delta)` | 일정한 물리 주기로 실행된다. 현재 캐릭터 이동과 충돌에 사용한다. |

`delta`는 해당 처리 호출 사이에 지난 시간(초)이다. 속도에 곱하면 시간에 따른 이동량을 구할 수 있다. 현재 `move_and_slide()`는 내부에서 물리 시간 간격을 반영하므로 `velocity`에 `delta`를 곱하지 않는다.

## 자식 참조와 벡터

```gdscript
func _ready() -> void:
    $Camera2D.enabled = controllable
```

`$Camera2D`는 현재 Node 기준으로 `Camera2D`라는 자식을 참조한다. 이름과 경로는 실제 Scene과 일치해야 한다.

`Vector2`는 x와 y 두 값을 가진 벡터다. 2D 위치나 이동 방향을 표현한다. Godot 2D에서는 오른쪽이 +x, 아래쪽이 +y다. `Vector2.ZERO`는 `(0, 0)`이며, 현재 조작 불가능한 Player의 속도를 초기화한다.

관련 문서: [캐릭터 이동](03-character-movement.md), [Scene과 Instance](05-scene-and-instance.md).
