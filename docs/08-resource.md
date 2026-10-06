# Resource

## Node와 Resource의 차이

Node는 Scene Tree에서 역할을 수행하는 객체다. Resource는 Node 등이 사용하는 데이터를 담는다.

| Resource 예 | 역할 |
| --- | --- |
| Texture | Sprite2D 등에 표시할 이미지 데이터. 현재 `icon.svg`를 사용한다. |
| Shape | 충돌 모양 데이터. 현재 `RectangleShape2D`를 사용한다. |
| Material | 그리는 방식에 필요한 설정 데이터. 개념 예시이며 현재 별도 Material을 설정한 것은 아니다. |

예를 들어 CollisionShape2D는 Node이고, 그 `shape` 속성이 참조하는 RectangleShape2D는 Resource다.

## 복제해도 공유될 수 있다

Node를 복제한다고 내부 Resource까지 반드시 복제되는 것은 아니다. 서로 다른 CollisionShape2D가 같은 RectangleShape2D를 참조할 수 있다. 이때 한 곳에서 Shape 크기를 바꾸면 같은 Resource를 참조하는 다른 Node의 충돌 모양도 바뀐다.

사방 벽을 만드는 과정에서 이 현상을 경험했다. Node는 별개였지만 Shape 데이터가 공유되어 있었다.

## Make Unique

각 벽의 충돌 크기를 독립적으로 설정해야 하므로 Inspector의 Shape Resource 메뉴에서 **Make Unique**를 사용했다. 해당 참조에 독립된 Resource를 만들어 이후 크기 변경이 다른 벽에 영향을 주지 않게 했다.

현재 `main.tscn`에는 네 개의 RectangleShape2D가 각각 별도의 sub-resource로 저장되어 있고, 벽마다 다른 Shape를 참조한다. 공유 자체가 오류인 것은 아니며, 독립 편집이 필요한지에 따라 선택한다.

관련 문서: [충돌](04-collision.md), [Day 1 시행착오](../devlog/2026-10-06.md).
