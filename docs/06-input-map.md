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
