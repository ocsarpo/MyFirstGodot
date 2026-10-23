# Input Map

## 키 대신 행동을 정의하는 이유

Input Action은 특정 키 자체가 아니라 게임에서 수행할 행동을 뜻한다. 하나의 행동에 여러 입력을 연결하면 게임 로직은 실제 키를 몰라도 된다.

처음 `sprite_2d.gd`에서는 기본 Action인 `ui_left`, `ui_right`, `ui_up`, `ui_down`을 사용했다. 현재는 프로젝트의 **Project Settings → Input Map**에서 만든 이동 전용 Action을 사용한다.

| Action | 매핑한 입력 |
| --- | --- |
| `move_left` | A, 왼쪽 방향키 |
| `move_right` | D, 오른쪽 방향키 |
| `move_up` | W, 위쪽 방향키 |
| `move_down` | S, 아래쪽 방향키 |

현재 `project.godot`에는 물리 키 기준으로 저장되어 있다. A와 왼쪽 방향키가 모두 같은 `move_left` 행동으로 연결되므로 이동 코드는 하나면 된다.

## 입력을 방향 벡터로 변환

```gdscript
var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
```

인자 순서는 x의 음수·양수, y의 음수·양수 방향이다. 반환값은 `Vector2`이며 입력이 없으면 `(0, 0)`이다. 벡터 길이가 1을 넘지 않도록 제한하므로 대각선 입력으로 더 빠르게 이동하는 문제를 방지한다.

관련 문서: [캐릭터 이동](03-character-movement.md).

## 화면 버튼과 같은 Action 공유

2026-10-23 1차 작업에서는 모바일 이동 입력을 시험하기 위해 상하좌우 화면 버튼을 추가했다. Player의 `Input.get_vector()` 이동 코드는 유지하고 Main에서 버튼 Signal을 기존 Action으로 연결했다.

```gdscript
func _on_left_button_button_down() -> void:
    Input.action_press("move_left")

func _on_left_button_button_up() -> void:
    Input.action_release("move_left")
```

`action_press()`는 해당 Action을 눌린 상태로 만들고, `action_release()`는 해제한다. 오른쪽·위·아래도 같은 방식으로 `move_right`, `move_up`, `move_down`에 연결했다.

키보드 입력과 화면 버튼이 같은 Action을 사용하므로 Player는 입력 장치를 구분하는 별도 이동 코드를 갖지 않는다. 버튼 UI는 모바일 조작 구조를 검증하는 임시 단계이며 최종 방식은 아니다. 가상 조이스틱은 아직 구현하지 않았다.

버튼 Signal과 Mouse Filter는 [기본 UI](11-basic-ui.md)에 정리했다.
