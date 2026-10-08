# Area2D와 Signal

## 막는 물체와 감지하는 영역

CharacterBody2D는 캐릭터의 이동과 충돌 처리를 담당한다. Area2D는 다른 Physics Body가 영역에 들어오는 것을 감지할 수 있다. 이번 Item은 Player를 막는 벽 대신 접촉을 감지하는 영역으로 구성했다.

```text
Item (Area2D)
├─ Sprite2D          icon.svg로 외형 표시
└─ CollisionShape2D RectangleShape2D로 감지 범위 지정
```

현재 `item.tscn`의 사각형 Shape 크기는 123×123이다. 외형과 감지 영역은 별도 설정이다. 기본 충돌 개념은 [충돌](04-collision.md)을 참고한다.

## body_entered와 연결

Signal은 어떤 일이 발생했음을 알리는 이벤트다. `body_entered`는 Godot이 제공하는 Area2D Signal이며, Physics Body가 영역에 들어오면 해당 body를 전달한다.

이번에는 에디터에서 Signal을 연결했다. `item.tscn`에 `body_entered`와 `_on_body_entered`의 연결이 저장되어 있다. 처음에는 함수에서 body 이름을 출력하여 Player 진입 시 호출되는지 확인했다. 현재 코드는 다음과 같다.

```gdscript
func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        body.collect_item()
        queue_free()
```

### Group으로 역할 확인

Group은 Node를 역할에 따라 묶는 이름이다. `is_in_group("player")`로 그룹 소속을 확인하면 Node 이름 자체에 의존하지 않아도 된다. 현재 `player.tscn` 루트에 `player` 그룹이 설정되어 있어 Player와 DummyPlayer 모두 이 그룹을 가진다. `controllable`은 입력 조작 여부이며 그룹 소속과는 별개다.

### queue_free()

`queue_free()`는 현재 Node의 삭제를 예약한다. 즉시 삭제하는 호출은 아니며, Item 루트가 삭제될 때 Sprite2D와 CollisionShape2D 같은 자식도 함께 삭제된다. 이번에는 player 그룹인 body에 점수를 전달한 후 Item 삭제를 예약한다.

## score 상태와 사용자 정의 Signal

게임 진행 중 변하며 유지되는 값이 상태(state)다. 현재 Player 스크립트 파일 이름은 `gdscript.gd`이며, 각 Player Instance가 자신의 score를 가진다.

```gdscript
signal score_changed(new_score: int)
var score: int = 0
```

`signal`은 사용자 정의 Signal을 선언한다. `new_score: int`는 Signal과 함께 전달할 값이다. 아이템을 획득하면 다음 함수가 실행된다.

```gdscript
func collect_item() -> void:
    score += 1
    score_changed.emit(score)
```

`emit()`은 Signal을 발생시켜 연결된 함수에 현재 점수를 전달한다. 점수 출력으로 누적을 확인한 뒤 Signal 방식으로 바꾸었으며, 현재 파일의 점수 출력문은 주석 처리되어 있다.

## 직접 호출과 Signal의 역할

- `body.collect_item()`: Item이 들어온 body에 아이템 획득 처리를 직접 요청한다. 현재 구조에서는 player 그룹인 body에 이 함수가 있다고 가정한다.
- `score_changed.emit(score)`: Player가 점수 변경 사실을 알린다. Player는 Label의 위치나 UI 구현을 직접 알 필요가 없다.

기본 Signal은 Godot이 제공하고, 사용자 정의 Signal은 게임 코드에서 선언한다. 에디터 연결뿐 아니라 코드의 `connect()`로도 수신 함수를 연결할 수 있다. Main에서의 연결과 Label 갱신은 [기본 UI](11-basic-ui.md)에 정리했다.

## 현재 전체 흐름

```text
Player가 Item 영역에 진입
→ body_entered 발생
→ Item이 player 그룹 확인
→ Player.collect_item() 직접 호출
→ score 증가, score_changed.emit(score)
→ Main이 수신하여 Label 갱신
→ Item이 queue_free()로 삭제 예약
```

실습에서 아이템을 여러 개 획득하며 점수가 1, 2, 3으로 누적되는 것을 확인했다.
