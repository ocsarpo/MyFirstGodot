# Scene과 Instance

## Player를 별도 Scene으로 분리한 이유

`player.tscn`은 캐릭터의 Node 구성과 설정을 저장한 설계도다. `main.tscn` 내부에만 캐릭터를 구성하는 대신 별도 Scene으로 분리하면 같은 객체를 반복해서 배치할 수 있다. Scene은 화면뿐 아니라 캐릭터·몬스터·총알·상자 같은 재사용 가능한 객체 단위로도 쓸 수 있다. 현재 구현한 것은 Player다.

## Instance와 개별 상태

Instance는 Scene을 바탕으로 생성한 실제 객체다. 현재 `main.tscn`은 `player.tscn`을 두 번 인스턴스화한다.

| Instance 이름 | 위치 | controllable |
| --- | --- | --- |
| `CharacterBody2D` | `(517, 303)` | 기본값 `true` |
| `CharacterBody2D2` | `(123, 180)` | `false`로 재설정 |

둘은 같은 구조와 스크립트를 사용하지만 위치와 변수 상태는 개별적으로 가질 수 있다. 단, 내부 Resource까지 모두 독립적이라는 뜻은 아니다.

```gdscript
@export var controllable: bool = true
```

`@export` 덕분에 각 Instance의 Inspector에서 값을 설정할 수 있다. 현재 코드에서 `true`는 입력을 받아 움직이고, `false`는 `velocity`를 0으로 설정한다. 카메라 활성화에도 같은 값을 사용한다.

관련 문서: [Scene과 Node](01-scene-and-node.md), [Camera2D](07-camera2d.md), [Resource](08-resource.md).
