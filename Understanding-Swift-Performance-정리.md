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
Swift가 힙에 있는 메모리를 해제할 때 안전한지 아닌지를 아는 방법은 reference counting 이다(힙에 있는 어떤 인스턴스든 간에 레퍼런스의 개수를 세고 있음). **이 count는 인스턴스 자체에 유지한다.** 참조를 추가하거나 제거하면 카운팅을 증가 or 감소시키고, count가 0이되면 힙에서 안전하게 제거할 수 있음을 스위프트가 알게 됨.

여기서 명심해야 할 점은, 레퍼런스 카운팅을 증가 or 감소 시키는 것은 매우 자주 있는 operation이고, 여기에는 단순히 integer를 증가시키고 감소시키는 것 이상의 일들이 있다는 점이다.

**첫 째는 증가 or 감소를 실행시키기 위해 몇 가지 레벨의 간접참조(couple levels of indirection)가 필요하다는 것. 하지만 더 중요한 것은, Heap allocation 처럼, Thread safety를 고려해야한다는 점. 왜냐하면 references(카운팅이 아님을 유의)는 어떤 heap instance에든 간에 멀티 스레드 환경에서 동시에 추가되거나 제거될 수 있어서 그래서 실제로 아토믹하게 reference count를 증가시키고 감소시켜야 한다.** 

```swift
// Reference Counting
// Class

class Point {
	var x, y: Double
	func draw() { ... }
}

let point1 = Point(x: 0, y: 0)
let point2 = point1
point2.x = 5
// use `point1`
// use `point2`
```

```swift
// Reference Counting
// Class (generated code)

class Point {
	var refCount: Int // 추가됨
	var x, y: Double
	func draw() { ... }
}

let point1 = Point(x: 0, y: 0)
let point2 = point1
retain(point2) // 추가됨
point2.x = 5
// use `point1`
release(point1) // 추가됨
// use `point2` 
release(point2) // 추가됨
```

두 번째 코드는 스위프트가 생성해주는 코드라고 보면 됨(이해를 위해 좀 제네럴하게 만들어둔 듯 함). retain, release 둘다 아토믹하게 reference count를 증가 or 감소 시킨다.

**클래스는 Heap에 생성되기 때문에 스위프트는 그 heap 할당을 관리해줘야 한다. 그걸 이제 reference counting으로 하는 것. reference counting operation이 비교적 자주 일어나고, reference counting의 atomicity 때문에 사소하지 않음. (+ This is just one more resent to use struct. ← 의미를 잘 몰라서 원문으로 둠)**

 하지만 구조체가 reference를 포함하는 경우(프로퍼티로 가지는 등), 얘네들 또한 reference counting overhead를 지불해야 함. 구조체는 걔네가 가지고있는 reference counting 수만큼 비례해서 오버헤드를 견뎌야 함. 그래서 하나 이상의 reference가 있다면 클래스보다도 더 많은 reference counting 오버헤드가 나올 수 있음.

```swift
// Modeling Techniques: Reference Counting

struct Attatchment {
	let fileURL: URL
	let uuid: String  레퍼런스 카운팅
	let mimeType: String 

	init?(fileURL: URL, uuid: String, mimeType: String) {
		guard mimeType.isMimeType
		else { return nil }
		
		self.fileURL = fileURL
		self.uuid = uuid
		self.mimeType = mimeType
	}		
}
```

구조체인데 레퍼런스 카운트를 여러 개 가지고 있어서, 더 개선할 여지가 있음.

```swift
// Modeling Techniques: Reference Counting

enum MimeType: String {
	case jpeg = "image/jpeg"
	case png = "image/png"
	case gif = "image/gif"
}

struct Attatchment {
	let fileURL: URL
	let uuid: UUID // 수정
	let mimeType: MimeType // 수정

	init?(fileURL: URL, uuid: UUID, mimeType: String) {
		guard let mimeType = MimeType(rawValue: mimeType)
		else { return nil }
		
		self.fileURL = fileURL
		self.uuid = uuid
		self.mimeType = mimeType
	}		
}
```

Stack에 이제 `Attachment`에 대해서 `fileURL`, `uuid`, `mimeType` 이 생성될 텐데, 이때 `fileURL`을 제외하고는 reference counting이 없을 것. `uuid` 와 `mimeType` 이 더이상 String이 아니기 때문에 훨씬 더 type safe하다고 할 수 있고(아무 문자열 값이나 넣지 못하게 됨), reference counting overhead도 적게 듬. 왜냐하면 `uuid`, `mimeType` 이 더이상 reference count나 heap allocated 될 필요 없기 때문.

## Method dispatch
Static dispatch → 컴파일 타임에 어떤 메소드 구현체(implementation)를 실행할지 아는 경우를 말함. 그래서 런타임에는, 바로 실제 구현체로 jump할 수 있음. 그래서 컴파일러가 되게 공격적으로 최적화를 해서 성능을 높일 수 있음(inline 등의 기법을 사용해서)

Dynamic dispatch → 컴파일 타임에 어떤 구현체로 바로 가야할지 결정할 수 없음. 그래서 런타임에, 우리는 실제 구현체를 찾아보고 거기로 jump해야 함. 그래서 자체적으로 dynamic dispatch는 static dispatch에 비해 그렇게 많이 비싸진 않음. 걍 하나 수준의(one level)의 indirection이 있는 거니. Reference counting 때 혹은 heap allocation 때 필요했던 스레드 동기화 오버헤드가 필요 없음. **그러나!!!! dynamic dispatch는 컴파일러의 시야를 막아서 최적화를 할 수 없게 한다(static dispatch일 경우 할 수 있는 inlining이나 다른 최적화들).**

그래서 Inline은 무엇인가? ⇒ 컴파일러가 chain of static dispatch(함수나 메소드 호출의 체인 정도로 보면 됨)을 보고, 최적화를 하는 기법. 함수 호출 or 메소드 호출 등의 코드를 실제 구현체로 바꿔치기 해서, 이 dispatch 체인을 마치 하나의 구현체처럼 최적화 시킬 수 있음. 그래서 콜스택 오버헤드 같은 게 사라짐. Dynamic dispatch의 경우 chain of dynamic dispatch에서 매번 호출 때마다 구현체를 찾는 동작으로 블로킹될 수 있음. 이게 체인이 짧으면 상관없지만 길면 길수록 성능차이가 날 수 있게 됨.

```swift
// Method Dispatch
// Struct (inlining)
struct Point {
	var x, y: Double
	func draw() { 
		// Point.draw implementation	
	}
}

func drawAPoint(_ param: Point) {
	param.draw()
}

let point = Point(x: 0, y: 0)
drawAPoint(point)
```

위의 코드의 경우 컴파일러가 `drawAPoiont(_:)` 호출부분을 `param.draw()` 로 바꿀 수 있고 또 이를 바꿔서 최종적으로 Point.draw implementation으로 바꿔치기 되면서 최적화 될 수 있다. 이는 아래와 같음.

```swift
// Method Dispatch
// Struct (inlining)
struct Point {
	var x, y: Double
	func draw() { 
		// Point.draw implementation	
	}
}

func drawAPoint(_ param: Point) {
	param.draw()
}

let point = Point(x: 0, y: 0)
// Point.draw implementation <- 최적화 결과물
```

그렇다면, 왜 Dynamic Dispatch 가 필요한가? 여러 이유가 있겠지만, 그 중 하나는 polymorphism과 같은 강력한 것을 가능하게 해주기 때문. 이를 활용해 다른 타입들이지만 공통의 부모 타입을 가진 타입들을 배열에 저장할 수 있는 것(부모 타입의 배열). 

```swift
class Drawable { func draw () }

class Point: Drawable {
	var x, y: Double
	override func draw() { ... }
}

class Line: Drawable {
	var x1, y1, x2, y2: Double
	override func draw() { ... }
}

var drawables: [Drawable]
for d in drawables {
	d.draw()
}
```

다른 타입의 객체들을 같은 배열에 저장이 가능한 이유는 어차피 레퍼런스 타입이라 해당 인스턴스에 대한 레퍼런스만 가지고 있기 때문. **그래서 컴파일러가 컴파일 타임에 어떤 구현체를 실행하는 게 맞는지를 결정할 수가 없는 것임. 실제 인스턴스가 무엇인지는 런타임에 결정된다.** 그러면 어떤 구현체가 호출되는지를 어떻게 알 수 있을까?

**컴파일러가 클래스에 다른 필드를 추가하여 이를 알 수 있다. 이 필드는 포인터인데, 해당 클래스의 type information에 대한 포인터이다.** 그리고 이 type information은 static memory에 저장되어 있다. (설명을 조금 추가하자면, static memory에는 실제 클래스에 대한 정보가 저장되어 있는 것. 그래서 메소드 구현체들도 여기 있어서, 실제로 우리가 클래스의 메소드를 호출할 때면 이곳으로 jump한다고 생각하면 된다. 그래서 이 type information에 대한 포인터를 보고, 실제 클래스의 type information을 찾아낼 수 있는 것)

**그래서 우리가 메소드 draw 메소드를 호출할 때, 컴파일러가 실제로 우리를 대신하여 생성하는 것은 실행할 올바른 구현에 대한 포인터를 포함하는 type 및 static memory에 대한 virtual method table이라는 type을 조회하는 것이다**(And so when we go and call draw, what the compliler actually generates on our behalf is a lookup through the type to something called the virtual method table on the type and static memory, which contains a pointer to the correct implementation to execute).

```swift
class Drawable { func draw () }

class Point: Drawable {
	var x, y: Double
	override func draw() { ... }
}

class Line: Drawable {
	var x1, y1, x2, y2: Double
	override func draw(_ self: Line) { ... }
}

var drawables: [Drawable]
for d in drawables {
	d.type.vtable.draw(d)
}
```

그래서 실제로 컴파일러가 우리를 대신해서 하는 대로 코드를 변경해보면, 실제로 실행한 올바른 draw 구현체를 찾기 위해 virtual method table을 조회하는 것을 알 수 있다. 그리고 실제 인스턴스를 암묵적인 self-parameter로 전달하고 있다.

클래스는 기본적으로 자신의 메소드를 dynamic dispatch한다. 이 점은 그 자체로 큰 차이를 만들진 않지만(혼자 호출하고 이런 것) method chaining이나 다른 것들에 대해선 optimization을 막을 수 있다(inlining이나 다른 추가될 수 있는 것들). 

다만 모든 클래스가 dynamic dispatch를 필요로 하는 건 아닌데, 클래스가 subclass되는 것을 의도하지 않는다면 final 키워드를 붙여서 이를 표시할 수 있다. final을 붙임으로써 미래의 나 스스로 혹은 팀원들에 대해서 ‘난 이 클래스를 상속시키지 않을거얏!’이라고 의도를 나타낼 수 있다. 그러면 컴파일러는 이걸 보고 이 메소드를 statically dispatch 한다. (추가로 컴파일러가 ‘우리 앱에서 클래스가 상속하지 않음'을 추론하고 증명해낸다면, opportunistically하게 dynamic dispatch들을 우리를 대신해서 static dispatches로 바꿀 것임. 이것에 대해 더 자세한 건 “Optimizing Swift Performance 라는 WWDC 2015 영상을 참고할 것).

### **Swift 코드를 읽고 쓸 때마다, 이 세가지 질문에 대해서 스스로 계속 물어볼 것.**

1. “이 인스턴스가 stack에 할당되는가 아니면 heap에 할당되는가?”
2. “인스턴스를 주고받을 때, 얼마나 많은 reference counting을 내가 발생시키게 될까?”
3. “내가 이 인스턴스의 메소드를 호출할 때, 이게 statical 하게 dispatch 될까 dynamical 하게 dispatch 될까?”. 

만약 우리가 필요없는 dynamicsm에 대해서 코스트를 지불하고 있다면, 이건 우리의 퍼포먼스를 나쁘게 할 것이다.

## Protocol types

**Polymorphism without inheritance or reference semantics**

```swift
protocol Drawable { func draw() }

struct Point: Drawable {
	var x, y: Double
	func draw() { ... }
}

struct Line: Drawable {
	var x1, y1, x2, y2: Double
	func draw() { ... }
}

var drawables: [Drawable]
for d in drawables {
	d.draw()
}
```

reference semantic이 발생시킬 수 있는 의도하지 않은 sharing을 막기 위해 class가 아닌 struct 타입으로 바꾸고, `Drawable` 프로토콜을 준수하도록 함. 

### Protocol Witness Table

- 프로토콜을 구현하고 있는 타입별로 하나씩 테이블이 존재함. 그 테이블의 엔트리들은 타입 내의 구현체를 연결한다(Point 구조체의 경우, draw의 실제 구현체를 가리킨다고 생각하면 됨).

그렇다면 array의 엘리먼트에서 그 테이블로는 어떻게 갈 수 있을까? 그리고 `Point` 와 `Line` 은 요구하는 word의 크기가 다른데 어떻게 같은 타입의 배열에 저장할 수 있는 걸까?(같은 사이즈가 아님) → Swift는 ‘Existential Container’ 라는 특별한 storage layout을 사용한다.

### Existential Container

- 처음 3개의 word는 valueBuffer를 위해 예약되어 있음. `Point`와 같이 2개의 word만 필요한 작은 타입은 이 valueBuffer에 들어 맞음.
- 그런데 `Line`은 4개의 word가 필요함. 그래서 이 경우엔 Swift가 힙에 있는 메모리를 할당하고, 거기에 데이터를 저장하고, 그것에 대한 포인터를 existential cotainer에 유지한다.
- `Point`, `Line` 가 차이가 있으니, 이걸 existential container가 어떻게 관리할 수 있을까. ⇒ Table based mechanism ⇒ ‘**Value Witness Table**’

### Value Witness Table(VWT)

- VWT는 value의 라이프타임을 관리함(allocate, copy, destruct, deallocate)
- 타입별로 이러한 테이블 중 하나가 있음.

지역변수의 라이프타임을 한번 보자(이 테이블의 동작에 대한 예시)

1. protocl type의 지역변수의 라이프타임이 시작할 때, Swift는 Value Witness Table 안의 allocate 함수를 호출한다. 이 함수는 힙 영역에 메모리를 할당하고, 그 메모리를 가르키는 포인터를 Existential container의 valueBuffer에다가 저장한다.
2. Swift는 지역변수를 초기화하는 그 assignment의 source로부터 Existential container로 값을 복사할 필요가 있다. `Line`의 경우, VWT의 copy entry가 힙에 있는(아까 할당받아 둔 힙에 있는 value buffer) 메모리 부분에다가 값을 복사해둘 것임
3. 프로그램이 동작하고, 지역변수의 라이프 타임이 끝날 때면, Swift는 VWT의 destruct entry를 호출할 것임. 이 타입이 들고 있었던 변수에 대한 reference count가 있다면 감소시킬 것임.(Line은 레퍼런스 타입을 들고 있는 게 없으니 이런 작업이 필요 없음)
4. 끝으로, Swift는 deallocate 함수를 호출하여 이 값을 위해 힙에 할당되었던 메모리를 해제시킴.

그렇다면 어떻게 VWT로 갈 수 있을까?

→ Existential Container에 VWT에 대한 참조가 있음.

그렇다면 어떻게 Protocol Witness Table로 갈 수 있을까?

→ 당연히 이것도  Existential Container에 PWT에 대한 참조가 있음.

**즉, Existential Container가 중심처럼 되어있음. 5 word로 구성되었고 3개는 valueBuffer, 1개는 VWT 참조, 1개는 PWT 참조이다.**

```swift
// Protocol Types
// The Existential Container in action
func drawACopy(local: Drawable) {
	local.draw()
}
let val: Drawable = Point()
drawACopy(val)

// psuedocode-------------------------
// 컴파일러가 만들어주는 코드라고 생각하면 됨
struct ExistContDrawable {
	var valueBuffer: (Int, Int, Int)
	var vwt: ValueWitnessTable
	var pwt: DrawableProtocolWitnessTable  
}

// drawACopy가 호출될 경우의 ----------------------
// Generated Code
func drawACopy(val: ExistContDrawable) {
	val local = ExistContDrawable()
	let vwt = val.vwt
	let pwt = val.pwt
	local.type = type
	local.pwt = pwt
	vwt.allocateBufferAndCopyValue(&local, val)
	pwt.draw(vwt.projectBuffer(&local)) // projectBuffer는 ExistCond에 valueBuffer 크기를 
// 넘어갈 경우가 있고(이러면 힙에 값이 있을 것임), 안넘어갈 경우가 있어서 이걸 추상화해주는 함수.
	vwt.destructAndDeallocateBuffer(temp)
}
```

Point, Line과 같은 struct가 Protocol과 결합하여 dynamic behavior, dynamic polymorphism을 갖게 됨. Line과 Point를 drawable protocol type의 array에 저장할 수 있게 됨. **이러한 dynamism이 필요하다면, 충분히 지불할 만한 가치가 있음. 앞선 class를 사용하는  예시와 비교했을 때, class 도 V-Table을 거쳐가야 하고, 또 클래스는 ref count 때문에 추가적인 오버헤드가 있기 때문임.**

여기까지 local variable이 어떻게 복사되는지, 그리고 method가 protocol type의 value에서 어떻게 dispatch 되는지를 봤음.

## Generics

