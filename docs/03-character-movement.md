# 캐릭터 이동

## 처음: Sprite2D 위치를 직접 변경

초기 코드가 `sprite_2d.gd`에 남아 있다. 현재 `player.tscn`에 연결된 스크립트는 이 파일이 아니라 `gdscript.gd`다.

```gdscript
func _process(delta: float) -> void:
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    position += direction * speed * delta
```

`position`은 부모 기준의 위치다. `direction`은 입력 방향이며 오른쪽은 대략 `(1, 0)`, 위쪽은 `(0, -1)`이다. 속도에 `delta`를 곱해 프레임 사이의 이동량을 구하면 FPS에 따른 속도 차이를 줄일 수 있다. 이 방식만으로는 물리 충돌에 따른 이동 처리가 되지 않는다.

## 현재: CharacterBody2D로 이동과 충돌 처리

벽과 충돌하는 캐릭터를 만들기 위해 물리적 본체를 `CharacterBody2D`로 바꾸었다. 현재 속도는 `200.0`이다.

```gdscript
func _physics_process(delta: float) -> void:
    if controllable:
        var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
        velocity = direction * speed
    else:
        velocity = Vector2.ZERO

    move_and_slide()
```

`velocity`는 초당 이동 속도 벡터다. `move_and_slide()`가 이를 기반으로 실제 이동과 충돌 시 미끄러짐을 처리한다. 물리 이동이므로 `_physics_process()`에서 실행한다. 시간 간격은 함수 내부에서 반영하므로 속도에 `delta`를 다시 곱하지 않는다. 현재 인자 `delta`는 코드에서 직접 사용하지 않는다.

## Grounded와 Floating

- `Grounded`: 위쪽 방향을 기준으로 바닥·천장·벽을 구분한다. 플랫폼 게임에 적합하다.
- `Floating`: 충돌을 모두 벽으로 취급한다. 바닥·천장 구분이 필요 없는 탑다운 게임에 적합하다.

이 프로젝트에서는 두 캐릭터가 아래쪽 접촉 시 함께 움직이는 현상을 겪고 Floating으로 변경했다. 현재 `player.tscn`에는 `motion_mode = 1`로 저장되어 있다.

관련 문서: [Input Map](06-input-map.md), [충돌](04-collision.md), [Day 1 시행착오](../devlog/2026-10-06.md).
