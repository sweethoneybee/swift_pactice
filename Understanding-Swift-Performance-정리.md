# Understanding Swift Performance

[https://developer.apple.com/videos/play/wwdc2016/416/](https://developer.apple.com/videos/play/wwdc2016/416/)

추상화를 할 때는 아래 세 가지를 고려할 수 있어야 함

메모리 할당 | Stack vs Heap

Reference counting | Less vs More

Method dispatch | Static vs Dynamic

## Allocation

Swift는 메모리 관리를 알아서 해줌.

Stack은 굉장히 간단한 자료구조. push하고 pop하고 하면 끝남. stack pointer를 움직여주는 것만으로 메모리할당, 해제가 끝나는데, integer 하나 할당하는 정도의 수준으로 빠르다.

Heap은 다이나믹하지만 stack에 비해 덜 효과적인 자료구조. Stack은 할 수 없는, 다이나믹한 life time을 줄 수 있음. 대신 이건 조금 더 고급의 자료구조를 써야함. 그래서 heap에 메모리 할당을 하면 ‘메모리 할당을 위해 사용되지 않는 메모리 블록을 찾고, 해제할 땐 메모리에 다시 그 블록을 반납해야 함'.

**근데 이건 heap의 메인 코스트가 아니다. Heap에서는 Thread safety overhead가 꽤 큰 비용이 든다. Locking 이나 synchronization mechanizm을 사용해서 비용이 많이 듬.**

class로 객체를 생성할 때는 property가 잡아먹는 word 외에도 2 word가 메모리를 더 잡아먹는다(뒤에서 더 다룰 예정)

Class는 identity나 indrect storage와 같은 강력한 특징을 가진다. 그런데 우리가 추상화를 위해 그러한 특성이 필요하지 않다면, struct 를 사용함으로써 성능 향상을 기대할 수 있다. 그리고 struct는 class에서 일어날 수 있는 ‘의도하지 않은 상태 공유'에 강하다(class는 레퍼런스 타입이라 아무 곳에서나 상태가 변할 수 있어서 찾아내기 어렵다는 의미).

```swift
enum Color { case blue, green, gray }
enum Orientation { case left, right }
enum Tail { case none, tail, bubble }

var cache = [String: UIImage]()
func makeBallon(_ color: Color, orientation: Orientation, tail: Tail) -> UIImage {
    let key = "\(color):\(orientation):\(tail)" // serializing
    if let image = cache[key] {
        return image
    }
    ...
}

```

enum 인자들을 serializing해서 String으로 변환하고, 이것을 캐시의 키값으로 사용하고 있음. String은 이 키를 위한 적절한 타입이라고 할 수 없음. 이 String을 말풍선의 설정 공간으로 사용하고 있는데, 이것 대신에 걍 아무 문자열 값이나 넣어버릴 수도 있음(별로 안전하진 않다는 것). 또한 String은 정말 많은 것들을 나타낼 수 있음. 왜냐하면 String은 실제로 contents of its characters를 간접적으로(indirectly) 힙에  저장하기 때문. **그래서 이건 우리가 makeBallon 함수를 호출할 때마다 캐시 hit이 일어나도, 우리는 실제로는 heap allocation을 발생시키고 있는 것을 의미한다.**

```swift
enum Color { case blue, green, gray }
enum Orientation { case left, right }
enum Tail { case none, tail, bubble }

// configuration space를 나타내기 위해 구조체 추가
struct Attributes {
    var color: Color
    var orientation: Orientation
    var tail: Tail
}

var cache = [Attributes: UIImage]()

func makeBallon(_ color: Color, orientation: Orientation, tail: Tail) -> UIImage {
    let key = Attributes(color: color, orientation: orientation, tail: tail)
    if let image = cache[key] {
        return image
    }
    ...
}
```

struct로 configuration space를 나타내는 건 String으로 나타내는 것보다 훨씬 더 안전하다고 할 수 있음. 또 스위프트에서 struct는 first class type이기 때문에 dictionary의 키로도 사용할 수 있으니 캐시의 키로도 사용할 수 있음.

이제는 makeBallon을 호출할 때 캐시 hit이 되면 더이상 heap allocation을 유발하지 않음. 왜냐하면 이런 구조체형태의 Attributes는 heap allocation을 필요로 하지 않기 때문. 걍 stack에 할당됨. 그래서 훨씬 더 안전하고, 더 빠르다고 할 수 있음.

## Reference counting

## Method dispatch

## Protocol types

## Generics

