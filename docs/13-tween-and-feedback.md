# Tween과 획득 피드백

득점했다는 사실을 눈으로 느낄 수 있도록 Item 획득과 Score Label에 크기 변화를 추가했다. 이번 Game Feel 학습은 이 시각적 피드백과 Item 대기 연출에 한정한다. 사운드와 사망 연출은 아직 구현하지 않았다.

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

TRANS_SINE은 사인 곡선 기반으로 값이 변하게 하고, EASE_IN_OUT은 시작과 끝에서 느리게 변화하도록 적용한다. 현재 이 설정은 idle Tween에 사용한다.

## Instance별 시작 시차

```gdscript
var delay = randf_range(0.0, 0.6)
await get_tree().create_timer(delay).timeout
```

`randf_range()`로 0~0.6초 사이 실수를 만들고 일회성 타이머의 `timeout`을 기다린다. 각 Item Instance가 `_ready()`를 독립적으로 실행하므로 서로 조금 다른 시점에 idle 연출을 시작한다. 대기 후 `collected`이면 반환해 새 idle Tween을 시작하지 않는다.

같은 `item.tscn`을 사용하므로 원본에 연결된 `item.gd`를 한 번 수정해 배치된 Item 모두에 공통 동작을 적용했다.

관련 문서: [Scene과 Instance](05-scene-and-instance.md), [Signal](10-area2d-and-signals.md), [UI와 Restart](11-basic-ui.md).
