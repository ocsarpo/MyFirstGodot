# 기본 UI

## CanvasLayer와 Label

월드의 Player를 카메라가 따라가더라도 점수 UI는 화면에 고정되어야 한다. 이번에는 기본 설정의 CanvasLayer 아래에 Label을 두었다.

```text
Main의 루트 Node2D (main.gd)
└─ CanvasLayer
   └─ Label  초기 Text: Score: 0
```

CanvasLayer는 월드 카메라의 이동과 독립된 UI를 표시하는 데 사용했다. Label은 문자열을 화면에 표시하며 `text` 속성으로 내용을 바꾼다. 카메라의 기본 개념은 [Camera2D](07-camera2d.md)를 참고한다.

## Main이 점수와 UI를 연결

현재 `main.gd`는 조작 가능한 `Player`의 Signal을 코드로 연결한다.

```gdscript
func _ready() -> void:
    $Player.score_changed.connect(_on_score_changed)
```

`connect()`로 Signal 발생 시 실행할 함수를 등록한다. 여기서 `$Player`는 `main.tscn` 안의 실제 Instance 이름을 사용한 경로다. 현재 DummyPlayer의 Signal은 이 UI에 연결하지 않는다.

```gdscript
func _on_score_changed(new_score: int) -> void:
    $CanvasLayer/Label.text = "Score: " + str(new_score)
```

Signal이 전달한 정수 점수를 `str()`로 문자열로 바꿔 Label에 표시한다. 실습에서는 아이템 획득에 따라 `Score: 0 → Score: 1 → Score: 2 → Score: 3`으로 갱신됨을 확인했다.

Player는 score를 관리하고 변경 사실을 알린다. Main은 그 알림을 받아 UI를 갱신한다. Player가 Label을 직접 수정하지 않으므로 점수 상태와 화면 표시의 역할을 나눌 수 있다.

관련 문서: [Area2D와 Signal](10-area2d-and-signals.md), [Scene과 Instance 이름](05-scene-and-instance.md).
