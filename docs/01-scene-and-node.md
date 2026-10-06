# Scene과 Node

## Node: 역할을 가진 구성 요소

Node는 Godot에서 게임을 구성하는 기본 단위다. 하나의 Node가 모든 일을 맡기보다 역할에 맞는 Node를 조합한다.

- `Node2D`: 위치·회전·크기를 갖는 2D Node의 기본형이다. 현재 `main.tscn`의 루트다.
- `Sprite2D`: Texture를 화면에 표시한다. 현재 Player는 `icon.svg`를 사용한다.
- `Polygon2D`: 다각형을 그린다. 현재 벽의 외형을 표현한다.

## Scene과 Scene Tree

Scene은 루트 Node와 그 자식들의 구성을 저장한 재사용 가능한 단위다. `.tscn` 파일로 저장하며, 게임 화면뿐 아니라 캐릭터 하나도 Scene이 될 수 있다.

Node의 부모·자식 관계가 트리 구조를 만든다. 실행 중에는 Scene의 Node들이 Scene Tree에 들어간다. 자식 Node2D는 부모의 Transform(위치·회전·크기)의 영향을 받는다.

현재 Player 구성은 다음과 같다. 표시는 역할 중심이며, 파일의 자식 순서와는 다르다.

```text
CharacterBody2D
├─ Sprite2D          외형
├─ CollisionShape2D 충돌 모양
└─ Camera2D         시야
```

`main.tscn`의 실제 루트 이름은 `Node2D`다. 그 아래 Player 인스턴스 두 개와 벽 `StaticBody2D` 네 개가 있다. 즉 하나의 게임 객체도 여러 Node의 조합으로 만든다.

관련 문서: [Scene과 Instance](05-scene-and-instance.md), [충돌](04-collision.md).
