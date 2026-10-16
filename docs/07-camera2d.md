# Camera2D

## Player의 자식으로 둔 이유

Camera2D는 2D 월드에서 화면에 보여줄 위치를 정한다. Player의 자식으로 두면 부모의 Transform을 따라 움직이므로 캐릭터를 추적하기 쉽다.

초기에는 Player Scene을 두 번 배치해 조작 가능한 Player의 카메라만 활성화했다. 현재는 DummyPlayer를 제거하고 Player 하나를 사용한다.

```gdscript
func _ready() -> void:
    $Camera2D.enabled = controllable
```

`enabled`는 카메라의 활성 여부다. `_ready()`에서 초기값을 연결한다. 현재 코드는 실행 중 `controllable`을 변경할 때 카메라를 자동으로 다시 설정하는 구조까지 구현한 것은 아니다.

## Position Smoothing

스무딩을 끄면 카메라는 목표 위치를 즉시 따라간다. 켜면 약간 늦게 부드럽게 따라간다. 현재 `player.tscn`은 `position_smoothing_enabled = true`, `position_smoothing_speed = 3.0`이다.

## 월드 위치와 화면에 보이는 위치

Player가 움직이면 실제 월드 위치는 변한다. 카메라도 따라가면 Player는 화면에서 비슷한 위치에 보일 수 있다. 스무딩과 Limit 때문에 항상 정확히 같은 화면 위치에 고정되는 것은 아니다.

`position`은 부모 기준 위치이며, 월드 위치와 항상 같은 것은 아니다. 현재처럼 루트의 Transform이 기본값인 단순한 구성에서는 두 위치가 일치할 수 있다.

## Camera Limit

이전 Limit 값인 왼쪽 `0`, 위쪽 `0`, 오른쪽 `1600`, 아래쪽 `900`은 파일에 남아 있지만 현재 `limit_enabled = false`로 비활성화되어 있다. 맵을 넓히면서 Player를 계속 따라가도록 변경했다. Limit을 활성화하면 카메라의 스크롤 범위를 제한한다.

Limit은 시야 제한이다. 현재 Player의 이동 제한은 Wall TileMapLayer의 Collision 타일이 담당한다.

## Window Size와 Camera Zoom

현재 기본 viewport 크기는 `1280 × 720`으로 설정했다. 16:9 화면을 기준으로 사용한다.

Camera2D의 실제 Zoom 값은 `(0.6, 0.6)`이다. 1보다 작게 설정해 월드의 Player·Enemy·Item·타일이 작게 보이고 더 넓은 영역이 화면에 들어오게 했다. CanvasLayer의 UI는 월드 Camera Zoom의 영향을 받지 않는다.

관련 문서: [충돌](04-collision.md), [Scene과 Instance](05-scene-and-instance.md).
