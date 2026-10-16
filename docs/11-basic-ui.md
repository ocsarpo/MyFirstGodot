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
    $Player.died.connect(_on_player_died)
```

`connect()`로 Signal 발생 시 실행할 함수를 등록한다. 여기서 `$Player`는 `main.tscn` 안의 실제 Instance 이름을 사용한 경로다. 학습용 DummyPlayer는 현재 제거되었다.

```gdscript
var label = $CanvasLayer/Label
label.text = "Score: " + str(new_score)
```

위는 `_on_score_changed()`의 텍스트 갱신 부분이다. Signal이 전달한 정수 점수를 `str()`로 문자열로 바꿔 표시하고, 현재는 이어서 Label 확대·복귀 Tween을 실행한다. 자세한 값과 대상은 [Tween 문서](13-tween-and-feedback.md)에 정리했다.

Player는 score를 관리하고 변경 사실을 알린다. Main은 그 알림을 받아 UI를 갱신한다. Player가 Label을 직접 수정하지 않으므로 점수 상태와 화면 표시의 역할을 나눌 수 있다.

## 사망 알림을 GAME OVER로 표시

Main은 `_ready()`에서 연결한 `died` Signal을 다음 함수로 받는다.

```gdscript
func _on_player_died() -> void:
    is_game_over = true
    $CanvasLayer/Label.text = "GAME OVER\n Press R to Restart"
```

별도 화면을 만들지 않고 기존 점수 Label의 문자열을 바꾼다. Player가 사망 상태와 이동 중단을 담당하고 Main이 화면 표시를 담당한다.

`$Player`는 현재 스크립트가 붙은 Node 기준 `get_node("Player")`의 축약 문법이다. 클래스 이름이나 Scene 파일명이 아니라 Scene Tree의 Node 이름을 따른다. Main의 실제 루트 이름은 `Node2D`이며, `$CanvasLayer/Label`은 그 아래 CanvasLayer와 Label 경로를 따라간다.

관련 문서: [Area2D와 Signal](10-area2d-and-signals.md), [Scene과 Instance 이름](05-scene-and-instance.md).

## Game Over 이후 Restart

Main은 `var is_game_over: bool = false`로 상태를 시작한다. Player 사망 시 참으로 바꾸고 안내를 표시한다.

```gdscript
func _process(delta: float) -> void:
    if is_game_over and Input.is_action_just_pressed("restart"):
        get_tree().reload_current_scene()
```

Input Map의 `restart`에는 R 키가 연결되어 있다. `is_action_just_pressed()`는 Action을 누르기 시작한 프레임에만 참이므로 누르고 있는 동안 계속 요청하는 것을 피한다. 현재 코드는 Game Over 상태에서만 재시작한다.

`get_tree()`로 SceneTree에 접근하고 `reload_current_scene()`으로 현재 Scene을 다시 로드한다. 이번 프로젝트의 Player 상태·Score·아이템·Enemy 위치·Main의 Game Over 상태는 Scene과 스크립트의 초기값으로 돌아간다. 각 값을 수동 초기화하는 대신 현재 Scene을 새로 구성해 최소 게임 루프를 완성했다.
