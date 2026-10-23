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
    $CanvasLayer/RestartButton.hide()
    $Player.score_changed.connect(_on_score_changed)
    $Player.died.connect(_on_player_died)
    get_tree().paused = true
```

`connect()`로 Signal 발생 시 실행할 함수를 등록한다. 여기서 `$Player`는 `main.tscn` 안의 실제 Instance 이름을 사용한 경로다. 학습용 DummyPlayer는 현재 제거되었다.

```gdscript
var label = $CanvasLayer/Label
label.text = "Score: " + str(new_score)
```

위는 `_on_score_changed()`의 텍스트 갱신 부분이다. Signal이 전달한 정수 점수를 `str()`로 문자열로 바꿔 표시하고, 현재는 이어서 Label 확대·복귀 Tween을 실행한다. 자세한 값과 대상은 [Tween 문서](13-tween-and-feedback.md)에 정리했다.

Player는 score를 관리하고 변경 사실을 알린다. Main은 그 알림을 받아 UI를 갱신한다. Player가 Label을 직접 수정하지 않으므로 점수 상태와 화면 표시의 역할을 나눌 수 있다.

## 사망 알림을 GAME OVER로 표시

Main은 Player의 사망 연출 종료 후 전달되는 `died` Signal을 받는다. 다음은 `_on_player_died()`의 상태와 텍스트 설정 부분이다.

```gdscript
is_game_over = true
var label = $CanvasLayer/Label
label.text = "GAME OVER\nPress R to Restart"
```

별도 화면을 만들지 않고 기존 점수 Label의 문자열을 바꾼다. 이어서 Label을 작고 투명하게 설정하고 페이드 인·확대·복귀 Tween을 실행한다. Player가 사망 상태와 이동 중단을 담당하고 Main이 화면 표시를 담당한다. `modulate.a`와 `pivot_offset` 설정은 [Tween 문서](13-tween-and-feedback.md)를 참고한다.

`$Player`는 현재 스크립트가 붙은 Node 기준 `get_node("Player")`의 축약 문법이다. 클래스 이름이나 Scene 파일명이 아니라 Scene Tree의 Node 이름을 따른다. Main의 실제 루트 이름은 `Node2D`이며, `$CanvasLayer/Label`은 그 아래 CanvasLayer와 Label 경로를 따라간다.

관련 문서: [Area2D와 Signal](10-area2d-and-signals.md), [Scene과 Instance 이름](05-scene-and-instance.md).

## Game Over 이후 Restart

Main은 `var is_game_over: bool = false`로 상태를 시작한다. Player 사망 Tween이 끝나 `died`를 수신하면 참으로 바꾸고 안내 연출을 시작한다. 현재는 GAME OVER Tween 완료를 기다리지 않으므로 이 UI 연출 중에도 R로 재시작할 수 있다.

```gdscript
func _process(delta: float) -> void:
    if is_game_over and Input.is_action_just_pressed("restart"):
        get_tree().reload_current_scene()
```

Input Map의 `restart`에는 R 키가 연결되어 있다. `is_action_just_pressed()`는 Action을 누르기 시작한 프레임에만 참이므로 누르고 있는 동안 계속 요청하는 것을 피한다. 이 키보드 경로는 Game Over 상태를 확인한다.

현재는 CanvasLayer 아래 `RestartButton`도 추가했다. Main의 `_ready()`에서 숨기고, `_on_player_died()`에서 GAME OVER Tween을 등록한 뒤 표시한다. Tween 완료를 기다려 표시하는 구조는 아니다. 버튼의 `pressed` Signal은 `_on_restart_button_pressed()`에 연결되어 `get_tree().reload_current_scene()`을 직접 호출한다. R 키와 화면 버튼 모두 같은 Scene 재로드를 사용한다.

`get_tree()`로 SceneTree에 접근하고 `reload_current_scene()`으로 현재 Scene을 다시 로드한다. 이번 프로젝트의 Player 상태·Score·아이템·Enemy 위치·Main의 Game Over 상태는 Scene과 스크립트의 초기값으로 돌아간다. 각 값을 수동 초기화하는 대신 현재 Scene을 새로 구성해 최소 게임 루프를 완성했다.

현재는 다시 로드할 때 Main의 `_ready()`가 Pause를 설정하므로 Restart 후에도 시작 화면을 거친다.

## 시작 화면의 UI 구성

```text
CanvasLayer
├─ Label (점수 / GAME OVER)
└─ StartScreen (Control)
   └─ CenterContainer
      └─ VBoxContainer
         ├─ TitleLabel: MY FIRST GODOT
         └─ StartButton: START
```

Control은 UI의 위치와 크기를 다루는 기본 Node다. StartScreen과 CenterContainer에는 Full Rect Anchor Preset이 적용되어 부모 영역을 채운다. CenterContainer는 자식 VBoxContainer를 중앙에 배치하고, VBoxContainer는 제목과 버튼을 세로로 정렬한다.

## Pause 중 입력과 시작 전환

게임 실행 직후 Player와 Enemy가 움직이지 않도록 Main의 `_ready()`에서 `get_tree().paused = true`를 설정한다. Node의 Process Mode는 Pause 여부에 따라 처리할지를 정한다. 현재 Scene에서는 StartScreen 자체가 아니라 **StartButton에만 When Paused (`process_mode = 2`)**를 지정했다.

버튼의 `pressed` Signal은 Scene 파일에서 Main의 `_on_start_button_pressed()`에 연결되어 있다. Signal로 연결된 함수는 Main의 일반 프레임 처리가 Pause되어 있어도 호출될 수 있다.

전환 Tween에는 `tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)`를 설정해 Pause 중에도 실행되게 했다. StartScreen의 `modulate:a`를 0.25초 동안 0으로 줄이고, `await tween.finished` 이후 `hide()`와 `get_tree().paused = false`를 순서대로 실행한다. 단순히 투명해진 순간부터 플레이가 진행되는 것이 아니라 페이드 완료 뒤 Pause를 해제한다.

이로써 실행 → 시작 화면 → START → Fade Out → 플레이 → GAME OVER → R → 시작 화면으로 흐름이 연결된다. Alpha와 Tween의 기본 개념은 [시각적 피드백](13-tween-and-feedback.md)을 참고한다.

## 모바일 이동 테스트 UI

CanvasLayer 아래 `MobileControls`를 Full Rect Control로 추가하고 `LeftButton`, `RightButton`, `UpButton`, `DownButton`을 배치했다. 현재 버튼 위치는 고정 offset이며 기기별 표시 여부를 구분하는 코드는 없다.

MobileControls의 `mouse_filter = 2`는 Ignore다. 부모 Control의 빈 영역이 기존 UI의 마우스 입력을 가로막지 않게 하며, 자식 버튼의 입력 설정까지 Ignore로 바꾸는 것은 아니다.

| Signal | 이번 사용 |
| --- | --- |
| `button_down` | 버튼을 누르기 시작할 때 이동 Action 활성화 |
| `button_up` | 버튼을 놓을 때 이동 Action 해제 |
| `pressed` | 클릭이 성립할 때 START나 RESTART 실행 |

현재 Button의 기본 클릭 동작에서는 `pressed`가 놓을 때 발생한다. 이동은 누르고 있는 상태를 표현해야 하므로 down/up을 나눠 사용했다. Action 연결은 [Input Map](06-input-map.md)을 참고한다. 이 UI는 임시 테스트 단계로, 모바일 웹 전체 대응 완료를 의미하지 않는다.
