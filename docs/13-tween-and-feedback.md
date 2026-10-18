# Tween과 시각적 피드백

득점과 사망을 눈으로 느낄 수 있도록 Item·Score·Player Sprite·GAME OVER Label에 시각적 피드백을 추가했다. Item 대기 연출도 사용한다. 사운드는 아직 구현하지 않았다.

## Tween으로 값을 시간에 따라 변경

`create_tween()`으로 Tween을 만들고 `tween_property(대상, 속성, 목표값, 시간)`으로 변화시킨다. 현재 코드는 연속해서 등록한 동작을 순서대로 실행한다.

| 연출 | 대상 | 변화 | 시간 |
| --- | --- | --- | --- |
| Item 획득 | Item 루트 `self`의 scale | 1.2배로 확대 → 0으로 축소 | 0.08초 → 0.12초 |
| 점수 갱신 | Label의 scale | 1로 초기화 → 1.4배 → 1 | 0.08초 → 0.12초 |
| Item idle | Sprite2D의 scale | 1.08배 → 1, 반복 | 각 0.5초 |

## 획득 처리와 collected 상태

현재 `item.gd`의 처리 순서는 다음과 같다.

```text
body_entered → collected이면 반환 → player 그룹 확인
→ collected = true → collect_item()으로 점수 증가
→ Item 확대·축소 → await tween.finished → queue_free()
```

연출 중에는 Item이 Scene Tree에 남아 있으므로 `collected` 상태로 중복 획득을 막는다. `await tween.finished`는 해당 함수의 후속 처리를 Tween 종료까지 기다리게 하며 게임 전체를 멈추지는 않는다. 점수는 연출 종료가 아니라 획득 처리 시작 시 증가한다.

## self와 실제 대상 Node

`self`는 현재 스크립트가 붙은 객체다. `item.gd`에서는 Item, `main.gd`에서는 Main 루트다. Score Tween을 복사할 때 대상을 `self`로 남겨 Main 전체가 확대되는 경험을 했다. 현재는 `$CanvasLayer/Label`을 `label`로 참조해 Tween 대상으로 사용한다.

## 반복과 곡선

`create_tween().set_loops()`로 Item의 Sprite2D 확대·복귀를 반복한다. 루트 전체를 변화시키는 획득 Tween과 대상이 다르다.

```gdscript
tween.set_trans(Tween.TRANS_SINE)
tween.set_ease(Tween.EASE_IN_OUT)
```

TRANS_SINE은 사인 곡선 기반으로 값이 변하게 하고, EASE_IN_OUT은 시작과 끝에서 느리게 변화하도록 적용한다. 현재 이 설정은 Item idle과 Player 사망 Tween에 사용한다.

## Instance별 시작 시차

```gdscript
var delay = randf_range(0.0, 0.6)
await get_tree().create_timer(delay).timeout
```

`randf_range()`로 0~0.6초 사이 실수를 만들고 일회성 타이머의 `timeout`을 기다린다. 각 Item Instance가 `_ready()`를 독립적으로 실행하므로 서로 조금 다른 시점에 idle 연출을 시작한다. 대기 후 `collected`이면 반환해 새 idle Tween을 시작하지 않는다.

같은 `item.tscn`을 사용하므로 원본에 연결된 `item.gd`를 한 번 수정해 배치된 Item 모두에 공통 동작을 적용했다.

## Player 사망 연출과 알림 순서

`die()`는 사망 상태와 속도 0을 먼저 적용한다. 이후 `$Sprite2D`의 현재 scale을 `original_scale`에 저장하고, 0.1초 동안 `original_scale * 2.0`으로 확대한 뒤 0.25초 동안 `Vector2.ZERO`로 줄인다. `await tween.finished` 뒤 `died.emit()`을 호출하므로 약 0.35초의 사망 연출이 끝난 뒤 Main이 GAME OVER를 표시한다.

대상은 CharacterBody2D 루트가 아니라 외형을 담당하는 Sprite2D다. 따라서 이 Tween으로 물리 본체나 CollisionShape의 Transform을 함께 축소하지 않는다. Sprite가 안 보이게 되는 것이며 Player Node를 삭제하는 처리는 아니다.

## GAME OVER의 Alpha와 확대 기준점

Main은 Label을 `scale = Vector2(0.5, 0.5)`, `modulate.a = 0.0`으로 설정한다. `modulate`는 표시 색상에 곱하는 값이며 `a`는 Alpha다. Alpha 0은 투명, 1은 이 속성에 의한 투명도 감소가 없는 상태다.

현재 Tween은 다음 순서로 실행된다. 페이드 인과 확대가 동시에 실행되는 구성은 아니다.

| 순서 | 속성 | 목표 | 시간 |
| --- | --- | --- | --- |
| 1 | `modulate:a` | Alpha 1로 페이드 인 | 0.2초 |
| 2 | `scale` | `(2.0, 2.0)`으로 확대 | 0.15초 |
| 3 | `scale` | `Vector2.ONE`으로 복귀 | 0.1초 |

`label.modulate.a`는 코드로 Alpha에 접근하는 표기이고, `"modulate:a"`는 `tween_property()`에 전달하는 속성 경로다.

`label.pivot_offset = label.size / 2`는 Control인 Label의 확대·축소와 회전 기준점을 현재 크기의 중앙으로 설정한다. 화면 중앙에 배치하는 설정과는 다르며, Label 자체의 중앙을 기준으로 커지게 한다.

Main은 이 연출 시작 시 이미 `is_game_over = true`로 설정한다. 따라서 현재 R 재시작은 GAME OVER 연출 중에도 가능하다.

관련 문서: [Scene과 Instance](05-scene-and-instance.md), [Signal](10-area2d-and-signals.md), [UI와 Restart](11-basic-ui.md).
