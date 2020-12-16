# 구조체와 클래스

비슷함.

프로퍼티, 메소드, 서브스크립트, 초기화 블록, 확장(extends), 프로토콜은 공통점. 상속, 타입 캐스팅, 소멸화 구문, 참조에 의한 전달은 클래스만 존재.

네이밍 룰은 클래스 이름은 카멜케이스, 멤버들은 소문자로 시작하는 카멜 케이스(파스칼).

구조체에만 멤버와이즈 펑션(Memberwise Function)가 기본적으로 생성됨. 이 메소드는 모든 프로퍼티를 인자로 받아서 초기화 하는 메소드임

모든 프로퍼티는 초기화되어 있어야 빈 괄호 생성자를 사용할 수 있음 + 객체가 초기화 될 때는 모든 프로퍼티가 초기화되어있어야 함.

그나마 옵셔널 타입의 프로퍼티는 선언만 해도 nil 값으로 초기화되니 상관 없음.

## 구조체 값 전달 방식: Call By Value

구조체를 다른 변수나 상수에 대입하면 구조체에 있는 모든 값을 복사하여 새로운 객체를 만들어 대입함. 새로운 객체가 생성되는 것.

약간 눈여겨봐야할 점은, 구조체 인스턴스를 상수에 할당하면 프로퍼티 값을 변경할 수 없게 된다. 이는 인스턴스가 변수나 상수에 할당될 때 구조체 인스턴스에 정의된 프로퍼티 전체 값이 그대로 복사되는 구조여서 할당된 이후에 프로퍼티 값이 변경되면 저장된 값 자체가 변경되는 것으로 인식하기 때문.

## 클래스 값 전달 방식: Call By Reference

클래스 인스턴스는 참조로 값을 전달한다. 그래서 메모리를 해제할 때 다른 곳에서 더 이상 쓰고 있진 않는지를 잘 검사해야한다(번거롭지..). Object-C에서는 개발자가 했지만 스위프트에선 ARC(Auto Reference Counter) 객체를 통해서 이를 관리한다. '지금 클래스 인스턴스를 참조하는 곳이 모두 몇 군데인지 자동으로 카운트해주는 객체'이다.

추가로 봐야할 건, 클래스 인스턴스 간의 비교이다. 클래스는 참조타입이기 때문에 단순한 값 비교는 불가능하다. 그래서 같은 메모리 공간인지를 비교하는 연산자가 있는데, ===, !== 이다. 클래스 인스턴스의 주소를 보고 동일한 인스턴스인지 다른 인스턴스인지를 검사한다.

```swift
class VideoMode {
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let vs = VideoMode()
let ds = vs
let ts = VideoMode()
// 동일한 객체 참조
if vs === ds {
    print("vs와 ds는 동일한 VideoMode를 참조하고 있습니다.")
} else {
    print("vs와 ds는 서로다른 VideoMode를 참조하고 있습니다.")
}

// 서로 다른 객체 참조
if vs === ts {
    print("vs와 ds는 동일한 VideoMode를 참조하고 있습니다.")
} else {
    print("vs와 ds는 서로다른 VideoMode를 참조하고 있습니다.")
}
```

일반적인 지침으로 다음 조건에 하나 이상 해당하면 구조체를 사용하라고 한다.

> 1. 서로 연관된 몇 개의 기본 데이터 타입들을 캡슐화하여 묶는 것이 목적일 때
> 2. 캡슐화된 데이터에 상속이 필요하지 않을 때
> 3. 캡슐화된 데이터를 전달하거나 할당하는 과정에서 참조 방식보다는 값이 복사되는 것이 합리적일 때
> 4. 캡슐화된 원본 데이터를 보존해야 할 때

근데 음... 사실 대부분의 경우에 구조체보다는 클래스를 더 많이 쓰게 될 것 같아.

## Property(프로퍼티)

**새로운 관점인데, 프로퍼티의 역할을 단순히 값을 저장하는 데이 있다는 것으로 생각하면 안된다. 프로퍼티 중 일부는 값을 저장하지는 않지만 값을 제공하는 특성을 가진다(?)**

스위프트에서는 값에 대한 저장 여부를 기준으로 저장 프로퍼티, 연산 프로퍼티로 나뉜다. 부가적으로 스위프트에서는 프로퍼티 값을 모니터링하기 위해 프로퍼티 옵저버(Property Observer)를 정의하여, 사용자가 정의한 특정 액션과 반응하도록 처리할 수 있다. 이것은 우리가 직접 정의한 저장 프로퍼티, 상속받은 서브 클래스에서도 추가할 수 있다.

### Stored Property(저장 프로퍼티)

저장 프로퍼티는 일반적으로 알고 있는, 클래스 나에서 선언된 변수, 상수를 말한다. 

저장 프로퍼티를 선언할 때 초기화할 수 있지만, 선언할 때 반드시 해야하는 것은 아니다. 초기화 구문에서 해도 된다.

다만 클래스에서 프로퍼티를 선언할 때 초기값을 함께 할당하지 않으면 신경 쓸 것이 많아진다. 스위프트에서는 클래스 프로퍼티를 초기화하지 않아주면 nil값을 넣는데, nil값이 들어가려면 옵셔널 타입이어야하잖아? 그래서 프로퍼티 선언할 때 초기값을 넣을 수 없으면 옵셔널 타입으로 정의한다. 근데 이때 우리를 편하게 해주는 문법, 바로 묵시적 옵셔널 해제 타입이다. '절대 nil이 되지 않지만, 아무튼 옵셔널임'. ! 연산자를 통해서 옵셔널 타입으로 지정해두면 해제 처리 할필요 없이 일반 변수처럼 쓸 수 있으니 편리하다!

근데 굳이 옵셔널로 안해도 되는 경우가 있다. 초기화 구문에서 프로퍼티 값을 초기화해주면 프로퍼티를 굳이 옵셔널로 안해도 된다. 그러니깐, 프로퍼티가 초기화되는 순간은 곧 인스턴스가 생성될 때네. 헷갈릴 게 없어 명확해. 

```swift
// 초기화 구문으로 프로퍼티 초기화
class User {
    var name: String
    
    init() {
        self.name = ""
    }
}
```

```swift
// 프로퍼티를 옵셔널 타입으로
class User {
    var name: String?
}
 
// or
// 프로퍼티 값이 nil값이 되지 않을 자신이 있다면 묵시적 옵셔널 해제 타입을 사용하는 것이 편리!
class User {
    var name: String!
}
```

```swift
// 프로퍼티에 초기값 할당
class User {
    var name: String = ""
}
```

구조체에서 상수, 변수로 프로퍼티를 저장하는 예제이다. 간단히 훑어만 보자.

```swift
// 고정 길이 범위 구조체
struct FixedLengthRange {
    var startValue: Int // 시작값
    let length: Int // 값의 범위
}

// 가변 길이 범위 구조체
struct FlexibleLengthRange {
    let startValue: Int
    var length: Int
}

var rangeOfFixedIntegers = FixedLengthRange(startValue: 0, length: 3)
rangeOfFixedIntegers.startValue = 4

var rangeOfFlexibleIntegers = FlexibleLengthRange(startValue: 0, length: 3)
rangeOfFlexibleIntegers.length = 5
```

주의할 점은, 구조체의 경우 주소로 다루지 않고 값으로 다루기 때문에 구조체를 상수로 선언한 경우 프로퍼티의 값을 수정할 수 없게 된다(클래스는 상수로 선언해도 프로퍼티 값 수정 가능. 주소로 다루고 있으니깐!)

#### 지연 저장 프로퍼티

저장 프로퍼티 앖에 lazy 키워드를 붙이면, 이 프로퍼티는 클래스가 생성될 때도 선언만 될 뿐 초기화되지 않고 있다가 실제로 호출이 되면 초기화된다. 이를 지연 저장 프로퍼티라고 한다.

```swift
class OnCreate {
    init() {
        print("OnCreate!")
    }
}

class LazyTest {
    var base = 0
    lazy var late = OnCreate()
    
    init() {
        print("Lazy Test")
    }
}

let lz = LazyTest() // "Lazy Test"
lz.late // "OnCreate!"
```

#### 클로저를 이용한 저장 프로퍼티 초기화

클로저를 활용해서 저장 프로퍼티를 연산이나 로직 처리를 통해 얻어진 값을 통해서 초기화할 수 있다. 구문의 형식은 처음 배우는 거니 익혀두자.

```
let/var 프로퍼티명: 타입 = {
	정의내용
	return 반환값
}()
```

이렇게 정의된 클로저 구문은 클래스나 구조체 인스턴스가 생성될 때 같이 실행되서 초기값을 반환하고 이후에는 재실행되지 않는다. 저장 프로퍼티 값을 다시 참조해도 다시 호출되지 않고 값도 그대로다. 연산 프로퍼티와 비슷한 구문이지만 참조될 때마다 매번 재평가된 값을 반환하는 것과 다르다.

```swift
class PropertyInit {
    // 저장 프로퍼티 - 인스턴스 생성 시 최초 한 번만 실행
    var value01: String! = {
        print("value01 execute")
        return "value01"
    }()
    
    // 저장 프로퍼티 - 인스턴스 생성 시 최초 한 번만 실행
    var value02: String! = {
        print("value02 execute")
        return "value02"
    }()
}

let s = PropertyInit()
// value01 execute
// value02 execute

s.value01 // 실행결과 없음
s.value02 // 실행결과 없음

```

이번엔 lazy 구문과 조합하여 메모리 자원을 효율적으로 활용해보자.

```
lazy var 프로퍼티명 : 타입 = {
	정의 내용
	return 반환값
}()
```

lazy와 클로저 구문을 조합하면 프로퍼티가 최초 참조될 때만 클로저가 실행된다.

```swift
class PropertyInit {
    // 저장 프로퍼티 - 인스턴스 생성 시 최초 한 번만 실행
    var value01: String! = {
        print("value01 execute")
        return "value01"
    }()
    
    // 저장 프로퍼티 - 인스턴스 생성 시 최초 한 번만 실행
    var value02: String! = {
        print("value02 execute")
        return "value02"
    }()
    
    // 프로퍼티 참조 시에 최초 한 번만 실행
    lazy var value03: String! = {
        print("value03 execute")
        return "value03"
    }()
}

let s = PropertyInit()
s.value01 // 실행결과 없음
s.value02 // 실행결과 없음

s.value03 // value03 execute
s.value03 // 실행결과 없음
```

이처럼 lazy 키워드를 붙여서 정의한 저장 프로퍼티를 클로저 구문으로 초기화하면 최초 한 번만 로직이 실행되는 데다 실제로 참조되는 시점에 맞추어 초기화되기 때문에 메모리 낭비를 줄일 수 있다. 특히 네트워크 소켓 관련 개발을 할 때 서버와의 소켓 통신 채널을 최초 한 번만 연결해 둔 다음 이를 재사용하여 통신하는 경우가 대부분이기 때문에, lazy 프로퍼티를 클로저로 초기화하여 연결 객체를 저장하는 이같은 방식이 매우 효율적이다.

### Computed Property(연산 프로퍼티)

구조체와 클래스에서 저장 프로퍼티 외에 연산 프로퍼티를 정의해서 사용할 수 있음. 연산 프로퍼티도 필요한 값을 제공한다는 점에서 비슷하지만 실제 값을 저장했다가 반환하는 것이 아닌 다른 프로퍼티의 값을 연산 처리하여 간접적으로 값을 제공함. 

이때 다른 프로퍼티의 값을 참조하기 위해 내부적으로 사용하는 구문이 get 구문. 또한 선택적으로 set 구문을 추가하여 연산 프로퍼티에 값을 할당하거나 변경할 수 있다. 물론 연산 프로퍼티 자체가 값을 저장하지는 않으므로 이때 할당되는 값은 연산의 중요한 요소로 사용됨.

연산 프로퍼티의 형태는 다음과 같음.

```
class/struct/enum 객체명 {
	...
	var 프로퍼티명 : 타입 {
		get {
			필요한 연산 과정
			return 반환값
		}
		set(매개변수명) {
			필요한 연산구문
		}
	}
}
```

연산 프로퍼티는 다른 프로퍼티에 의존적이거나, 혹은 특정 연산을 통해 얻을 수 있는 값을 정의할 때 사용된다. 대표적인 것으로 개인 정보 중에서 나이가 이에 속한다. 나이는 출생연도에 의존적이며 현재 연도를 기준으로 계산해야 하므로 매년 그 값이 달라지니깐.

```swift
import Foundation

struct UserInfo {
    // 저장 프로퍼티: 태어난 연도
    var birth: Int!
    
    var thisYear: Int! {
        get {
            let df = DateFormatter()
            df.dateFormat = "yyyy"
            return Int(df.string(from: Date()))
        }
    }
    
    var age: Int {
        get {
            return (self.thisYear - self.birth) + 1
        }
    }
}


let info = UserInfo(birth: 1997)
print(info.age)
```

또 다른 예시로 특정 사각형에 대한 정보를 저장하는 구조체에서 연산 프로퍼티를 사용하여 사각형의 중심 좌표를 구하는 예제. 위 예제보다 조금 더 복잡함.

```swift
struct Rect {
    // 사각형이 위치한 기준 좌표(좌측 상단 기준)
    var originX: Double = 0.0, originY: Double = 0.0
    
    // 가로 세로 길이
    var sizeWidth: Double = 0.0, sizeHeight: Double = 0.0
    
    // 사각형의 X 좌표 중심
    var centerX: Double {
        get {
            return self.originX + (sizeWidth / 2)
        }
        
        set(newCenterX) {
            originX = newCenterX - (sizeWidth / 2)
        }
    }
    
    // 사각형의 Y 좌표 중심
    var centerY: Double {
        get {
            return self.originY + (self.sizeHeight / 2)
        }
        
        set(newCenterY) {
            self.originY = newCenterY - (self.sizeHeight / 2)
        }
    }
}

var square = Rect(originX: 0.0, originY: 0.0, sizeWidth: 10.0, sizeHeight: 10.0)
print("square.centerX = \(square.centerX), square.centerY = \(square.centerY)")
```

좌표 x, y와 가로세로 길이는 저장 프로퍼티로 정의되었지만 사각형의 중심 좌표는 이에 의존적이기 때문에 연산 프로퍼티로 설정되었다. 물론 연산 프로퍼티를 사용하지 않고 매번 중심 좌표를 저장 프로퍼티 값을 받아서 계산할 수도 있겠지만 그러면 코드가 반복되고 불편하다. 

연산 프로퍼티는 100% 필요하다기 보다는 다른 언어에선 get 메소드로 구현하는 걸 구현해놓은 느낌이다.

여기에 조금 더 욕심을 내서, 이 구조체를 객체지향에 맞게 개선해보자. Rect 구조체는 네 개의 저장 프로퍼티를 담고 있지만 이 프로퍼티들은 서로 연관성이 있는 두 개씩의 프로퍼티로 이루어져 있으니 이걸 기준으로 두 개의 구조체를 정의해보자

```swift
struct Position {
    var x: Double = 0.0
    var y: Double = 0.0
}

struct Size {
    var width: Double = 0.0
    var height: Double = 0.0
}

struct Rect {
    // 사각형이 위치한 기준 좌표(좌측 상단 기준)
    var origin = Position()
    
    // 가로 세로 길이
    var size = Size()
    
    // 사각형의 좌표 중심
    var center: Position {
        get {
            let centerX = self.origin.x + (self.size.width / 2)
            let centerY = self.origin.y + (self.size.height / 2)
            return Position(x: centerX, y: centerY)
        }
        
        set(newCenter) {
            self.origin.x = newCenter.x + (size.width / 2)
            self.origin.y = newCenter.y + (size.height / 2)
        }
    }
}

let p = Position(x: 0.0, y: 0.0)
let s = Size(width: 10.0, height: 10.0)

var square = Rect(origin: p, size: s)
print("square.centerX = \(square.center.x), square.centerY = \(square.center.y)")
```

연산 프로퍼티의 set 구문은 활용하기에 따라 다른 저장 프로퍼티의 값을 변경하는 데에도 사용할 수 있다. 여기서는 중심 좌표를 옮김으로써 기준 좌표의 위츠를 이동시켰다.

center 프로퍼티의 set 구문을 살펴보자. 연산 프로퍼티에 값을 할당하면 여기에 정의된 구문이 실행된다. 프로퍼티에 할당된 값은 set 다음에 오는 괄호의 인자값으로 전달되는 것이고, 이때 인자값의 참조를 위해 매개변수가 사용된다. 매개변수명이 생략된다면  'newValue'라는 기본 인자명이 사용된다.

그리고 타입도 적을 필요가 없다. 어차피 입력할 수 있는 타입은 연산 프로퍼티의 타입으로 정해져 있어서 매개변수에는 타입을 생략할 수 있는 것이다.

그럼 이제 중심 좌표의 값을 변경해보자.

```swift
square.center = Position(x: 20.0, y: 20.0)
print("square.centerX = \(square.origin.x), square.centerY = \(square.origin.y)")
```

연산 프로퍼티  center에 값을 할당하면 해당 인스턴스를 인자값으로 하는 set 구문이 실행된다. 그러면서  origin 프로퍼티의 x, y 서브 프로퍼티 값이 모두 바뀌었다.

그런데 이런 걸 방지해야할 때도 있다. 예를 들어 배열의 크기는 count로 알 수 있는데 임의로 count를 바꿔버리면 문제가 생길 것이다. 그래서 count 프로퍼티는 수정할 수 없도록 제약을 가해야한다.

이를 위해서는 set 구문만 제거하면 된다. 이러면 프로퍼티를 통해 값을 읽기만 할 뿐 할당은 할 수 없다. 이처럼 읽기만 가능하고 쓰기는 불가능한 프로퍼티를 **read-only 프로퍼티, 또는 get-only 프로퍼티라하고 우리말로 읽기 전용 프로퍼티라고도 한다.**

```swift
var center: Position {
  get {
    let centerX = self.origin.x + (self.size.width / 2)
    let centerY = self.origin.y + (self.size.height / 2)
    return Position(x: centerX, y: centerY)
  }
}
```

```swift
// 같은 구문 다른 문법
// 읽기 전용으로 설정된 연산 프로퍼티는 get 블록의 구분을 생략할 수 있음
var center: Position {
    let centerX = self.origin.x + (self.size.width / 2)
    let centerY = self.origin.y + (self.size.height / 2)
    return Position(x: centerX, y: centerY)
}
```

계속 내가 의아했던 것과 동일하게 연산 프로퍼티는 사실 메소드 형식으로 표현할 수 있다. 자바는 get, set 메소드로 이를 구분한다. 연산 프로퍼티의 get 구문이 get 메소드,  set 구문이 set 메소드로 대체되는 것. 오브젝트-C 도 연산 프로퍼티 구현 목적으로 get, set 메소드를 자동으로 만들어주기도 한다.

추가로 이 연산 프로퍼티의 get, set 구문은 C#에서 빌려온 개념이라고 한다.

## 프로퍼티 옵저버(Property Observer)

특정 프로퍼티를 계속 관찰하고 있다가 프로퍼티의 값이 바뀌면 무조건 호출된다. 같은 값이 재할당되어도 호출된다. 저장 프로퍼티, 연산 프로퍼티 set 구문이 실행되는 모든 경우 옵저버가 호출된다.

프로퍼티 옵저버에는 willSet 과  didSet이 있다. 둘은 다음과 같은 차이를 가진다.

> willSet - 프로퍼티의 값이 변경되기 전에 호출되는 옵저버
>
> didSet - 프로퍼티의 값이 변경된 직후에 호출되는 옵저버

willSet 옵저버에는 프로퍼티에 대입되는 값이 옵저버의 실행 블록에 매개상수로 전달된다. 이 값은 상수라 참조만 가능하고 수정할 수 없다. 또 이름을 부여하지 않을 수도 있는데 이 경우에는 괄호와 이름을 생략할 수 있고  newValue라는 이름으로 접근할 수 있다. willSet의 정의구문은 다음과 같다.

```
var <프로퍼티명> : <타입> [ = <초기값> ] {
	willSet [ (<인자명>) ] {
		<프로퍼티 값이 변경되기 전에 실행할 내용>
	}
}
```

계속 말하는 거지만 대괄호로 감싸져있는 부분은 생략해도 된다는 것임.

didSet 옵저버도 비슷한 특성을 가지는데, 얘는 새로 할당된 값이 아니라 기존에 저장되어 있던 값이 매개상수 형태로 전달된다. 또 이름 생략 가능하며 이 경우 oldValue 라는 이름으로 전달된다. 바뀐 값을 참조하고 싶으면 그냥 프로퍼티 참조하면 된다. 바뀐 후에 didSet이 호출되니깐.  didSet은 다음과 같이 정의된다

```
var <프로퍼티명> : <타입> [ = <초기값>] {
	didSet [ (<인자명>) ] {
		<프로퍼티값이 변경된 후에 실행할 내용>
	}
}
```

재미있는 예시코드는 다음과 같다

```swift
struct Job {
    var income: Int = 0 {
        willSet(newIncome) {
            print("이번 달 월급은 \(newIncome)원 입니다.")
        }
        
        didSet {
            if income > oldValue {
                print("월급이 \(income - oldValue)원 증가하셨네요. 소득세가 상향조정될 예정입니다.")
            } else {
                print("저런, 월급이 삭감되었군요. 그래도 소득세는 깎아드리지 않아요. 알죠?")
            }
        }
    }
}

var job = Job(income: 1000000)

job.income = 2000000

job.income = 1500000
```

이처럼 프로퍼티 옵저버는 프로퍼티에 구현해두면 그 이후에는 신경쓰지 않아도 알아서 동작하니 값의 변화를 주시하고 있어야할 때, 혹은 값의 변화에 따른 처리가 필요할 때 요긴하게 사용되는 기능이다.

## 타입 프로퍼티

저장, 연산 프로퍼티는 인스턴스 프로퍼티라고 부르고, 클래스나 구조체 열거형과 같은 객체 자체에 관련된 값을 타입 프로퍼티라 한다(스태틱 같은 애들인 듯). 인스턴스에 속하는 값이 아니라 클래스나 구조체 자체에 속하는 값이니 인스턴스를 생성하지 않고 클래스나 구조체 자체에 저장하게 되며 저장된 값은 모든 인스턴스가 공통으로 사용할 수 있다.

타입 프로퍼티의 모델이 되는 C, 오브젝티브-C에서 동일한 역할을 하는 global static 상수와 변수는 전역범위를 가지지만 스위프트에서 타입 프로퍼티는 선언된 객체 내에서만 접근 가능한 범위를 가진다(클래스, 구조체, 열거형 객체 내에 선언하기 때문)

타입 프로퍼티를 선언하는 요령은 두 가지가 있다. 저장 프로퍼티든 연산 프로퍼티든 앞에  static 키워드를 붙여주면 된다. 구조체나 클래스에 관계없이 가능하다. 또 class 라는 키워드를 사용할 수 있는데 이 키워드는 클래스에서 연산 프로퍼티에만 붙일 수 있는 키워드이다. 이 키워드를 사용하면 상속받은 하위 클래스에서 오버라이드 할 수 있는 타입 프로퍼티가 된다.

```swift
static let/var 프로퍼티명 = 초기값

// 또는

class let/var 프로퍼티명 : 타입 {
	get {
    return 반환값
  }
  set {
  }
}
```

변수나 상수 어느 것이든 타입 프로퍼티로 사용할 수는 있지만, 저장 프로퍼티의 경우 초기값을 반드시 할당해야 한다. 타입 프로퍼티는 인스턴스와 상관없기 때문에 인스턴스 생성 과정에서 초기값을 할당할 수 없기 때문이다(당연한 거네). 예시를 보자.

```swift
struct Foo {
    // 타입 저장 프로퍼티
    static var sFoo = "구조차 타입 프로퍼티값"
    
    // 타입 연산 프로퍼티
    static var cFoo: Int {
        return 1
    }
}

class Boo {
    // 타입 저장 프로퍼티
    static var sFoo = "클래스 타입 프로퍼티값"
    
    // 타입 연산 프로퍼티
    static var cFoo: Int {
        return 10
    }
    
    // 재정의가 가능한 타입 연산 프로퍼티
    class var oFoo: Int {
        return 100
    }
}

print(Foo.sFoo)
// "구조차 타입 프로퍼티값"

Foo.sFoo = "새로운 값"
print(Foo.sFoo)
// "새로운 값"

print(Boo.sFoo)
// "클래스 타입 프로퍼티값"

print(Boo.cFoo)
// 10
```

또 당연한 거지만, 접근할 때는 클래스나 구조체 열거형 자체를 통해서 점(.)으로 접근하는 것이다. 인스턴스로 접근하려면 오류가 난다.

## 메소드

프로퍼티처럼 인스턴스 메소드, 타입 메소드로 나뉘고 성격도 비슷하다. 타입 메소드는 오브젝티브-C의 클래스 메소드와 유사하다. 구조체 내의 메소드와 클래스 내의 메소드는 수정 여부에 대한 몇 가지 항목을 제외하면 거의 비슷하다.

```swift
struct Resolution {
    var width = 0
    var height = 0
    
    // 구조체의 요약된 설명을 리턴해주는 인스턴스 메소드
    func desc() -> String {
        let desc = "이 해상도는 가로 \(self.width) \(self.height)로 구성됩니다."
        return desc
    }
}

class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
    
    // 클래스의 요약된 설명을 리턴해주는 인스턴스 메소드\
    func desc() -> String {
        if self.name != nil {
            let desc = "이 \(self.name!) 비디오 모드는 \(self.frameRate)의 프레임 비율로 표시됩니다."
            return desc
        } else {
            let desc = "이 비디오 모드는 \(self.frameRate)의 프레임 비율로 표시됩니다."
            return desc
        }
    }
}
```

self 키워드는 클래스나 구조체 자신을 가리킨다. self를 붙이지 않아도 컴파일러가 프로퍼티를 잘 가져와주지만 동일한 이름을 가진 변수나 상수가 있는 경우 이를 구분하기 위해 self를 꼭 프로퍼티 앞에 붙여주자.

메소드도 클래스, 구조체, 열거형에 속해있다는 것 외에는 함수랑 거의 같기 때문에 매개변수 라벨이나 이름 역시 똑같다. 다만 주의할 점은, 구조체나 열거형의 인스턴스 메소드 내부에서 프로퍼티의 값을 수정할 때는 반드시 메소드 앞에  mutating이라는 키워드를 추가해야 한다. 이게 없이 메소드 내에서 값을 변경하고자 하면 오류가 난다. 또 구조체나 열거형 인스턴스를 상수로 할당받으면  mutating 메소드를 호출할 수 없게 된다. 상수에 할당받았으니 값을 수정할 수 없기 때문에. 

```swift
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveByX(x deltaX: Double, y deltaY: Double) {
        self.x += deltaX
        self.y += deltaY
    }
}

var point = Point(x: 10.5, y:12.0)
point.moveByX(x: 3.0, y: 4.5)
print("이제 새로운 좌표는 (\(point.x), \(point.y))입니다.")\
```

하지만 클래스 인스턴스 메소드는 별도의 키워드가 필요없이 맘껏 프로퍼티의 값을 수정할 수 있다.

## 타입 메소드

타입 프로퍼티와 동일한 개념이다. 역시  static 키워드로 선언 가능하고,  class 키워드는 클래스에서만 가능하고 상속받아서 재정의할 수 있는 타입 프로퍼티를 만드는 키워드다.

```swift
class Foo {
    // 타입 메소드 선언
    class func fooTypeMethod() {
        // 타입 메소드 구현 내용 들어감
    }
}

let f = Foo()
f.fooTypeMothod() // 오류
Foo.fooTypeMethod()
```

타입 메소드는 당연히! 인스턴스 프로퍼티를 참조할 수 없고 오직 타입 프로퍼티만을 참조할 수 있다.

## 상속

스위프트도 다른 객체지향에서 보이는 것과 마찬가지로 상속이 가능하다. 프로퍼티, 메소드를 물려주는 클래스에는 부모, 슈퍼, 상위, 기본 클래스 용어가 사용되고 물려받는 클래스에는 자식, 서브, 하위, 파생 클래스 용어가 사용된다.

C++와는 다르게 다중상속을 지원하지 않는다(사실 지원해도 쓰기는 위험이 많이 따르긴 하지...). 상속 받는 문법은 C++과 동일하게 클래스 이름 옆에 콜론(:)을 통해서 클래스 이름을 명시하는 것이고, 여기에 첫 번째로 쓴 클래스만 상속 가능하고 다른 것들은 구현체에 불과하다.

```swift
class A {
    var name = "Class A"
    
    var description: String {
        return "This class name is \(self.name)"
    }
    
    func foo() {
        print("\(self.name)'s method foo is called")
    }
}

class B: A {
    var prop = "Class B"
    
    func boo() -> String {
        return "Class B prop = \(self.prop)"
    }
}

let b = B()
b.prop // "Class B"
b.boo() // "Class B prop = Class B

b.name // "Class A"
b.foo() // "Class A's method foo is called"

b.name = "Class C"
b.foo() // "Class C's method foo is called"
```

우선 상속의 내용은 다른 객체지향 언어와 같은 내용이라 생략한다.

## 오버라이딩

자식 클래스에서 부모 클래스에게 상속받은 프로퍼티나 메소드를 재정의하면 이를 오버라이딩이라고 한다.

스위프트에는 override라는 키워드를 메소드나 프로퍼티 앞에 붙여야 오버라이딩할 수 있다. 그래서 개발자가 실수를 걱정할 필요 없이 마음놓고 자식 클래스에서 프로퍼티랑 메소드를 추가할 수 있다. override 키워드를 붙이지 않고 오버라이딩 하면 컴파일러가 오류를 잡아주고, 오버라이딩 하지 않는데 override를 붙여도 오류로 잡아준다. 편하다.

눈 여겨 봐야할 점은, 프로퍼티는 저장 프로퍼티이건 연산 프로퍼티이건 관계없이 오버라이딩을 하려면 모두 연산프로퍼티로 해줘야한다는 것이다. 저장 프로퍼티로 오버라이딩은 의미가 없고(그냥 재할당하면 되니깐) 연산 프로퍼티를 저장 프로퍼티로 오버라이딩 하는 것은 언산 프로퍼티 자체를 오버라이딩 하는 것으로도 충분히 가능하다. 

또 추가로 저장 프로퍼티는 읽고 쓰기가 모두 허용하는 만큼 연산 프로퍼티로 오버라이딩 할 경우에는 get, set 구문을 모두 제공해줘야한다. 같은 맥락에서 get, set을 모두 제공하던 연산 프로퍼티를 get 만 제공할 순 없다. 읽기만 제공한 프로퍼티는 get, set으로 확장가능하다. 정리하자면, 오버라이딩은 상위 클래스의 기능을 확장, 또는 변경하는 방식으로 진행해야하고 제한하는 방식으론 진행이 불가능하다. 예시를 보자.

```swift
class Vehicle {
    var currentSpeed = 0.0
    
    var description: String {
        return "시간당 \(self.currentSpeed)의 속도로 이동하고 있습니다."
    }
    
    func makeNoise() {
        // 임의의 교통수단에는 경적 필요 없음
    }
}

class Car: Vehicle {
    var gear = 0
    var engineLevel = 0
    
    override var currentSpeed: Double {
        get {
            return Double(self.engineLevel * 50)
        }
        set {
            // 아무것도 하지 않음
        }
    }
    override var description: String {
        get {
            return "Car : engineLevel=\(self.engineLevel), so currentSpeed=\(self.currentSpeed)"
        }
        set {
            print("New value is \(newValue)")
        }
    }
}

let c = Car()

c.engineLevel = 5
c.currentSpeed // 250
c.description = "New Class Car"

print(c.description)
```

저장 프로퍼티를 오버라이딩 할 때 set 구문이 아무일도 하지 않더라도 반드시 있어야한다(저장 프로퍼티가 읽고 쓰기가 가능하기 때문). 그래서 description 도 같은 맥락에서 get, set 을 구현해야한다.

또 상속하면서 프로퍼티가 상수나 읽기 전용 프로퍼티만 아니면 옵저버를 붙여줄 수도 있다.

(근데 아래 예시는, 지금 코드에서는 의미가 없는듯. 왜냐하면  currentSpeed는 할당해도 set 구문이 따로 일을 안하기 때문에 gear 변경도 의미가 없다)

```swift
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
           
            self.gear = Int(currentSpeed / 10.0) + 1 
        }
    }
}
```

메소드는 오버라이딩이 조금 더 까다롭다. 메소드 이름, 매개변수명, 매개변수 개수, 매개변수 타입, 리턴 타입이 전부 동일해야 오버라이딩이 된다. 매개변수의 타입과 종류가 다르면 서로 다른 메소드로 처리하는 것이 오버로딩이다. 다른 언어와 비슷한 특징을 보이지만 스위프트는 매개변수 명도 메소드 정의에 포함되어서 매개변수 개수, 타입이 일치해도 이름이 다르면 오버로딩 된다. 오버로딩 때에는 당연이  override 키워드를 붙이면 안된다.

프로퍼티와 메소드를 오버라이딩한 뒤에 상속받은 부모 클래스의 인스턴스를 참조하기 위해  super 라는 키워드를 사용한다. 바로 위의 부모클래스의 것만 참조할 수 있고 우리가 자신을 self. 으로 참조하듯이 super. 으로 참조하면 된다.

또 자바와 비슷하게,  final이라는 키워드를 통해서(또 베꼈냐! 스위프트! ) 메소드 오버라이드를 막을 수 있다. final 키워드는 메소드, 프로퍼티 앞에 붙이면 되고 클래스 자체에도 붙일 수 있다. final이 클래스에 붙으면 상속이 차단된다.

## 타입 캐스팅

다른 객체지향 언어에서와 마찬가지로, 상위 클래스를 상속받은 하위 클래스는 더 확장한 것이기 때문에 상위 클래스 타입으로 하위 클래스 객체를 할당할 수 있다. 반대는 일반적으로 성립되지 않는다.

```swift
class Vehicle {
    var currentSpeed = 0.0
    
    func accelerate() {
        self.currentSpeed += 1
    }
}

class Car: Vehicle {
    var gear: Int {
        return Int(self.currentSpeed / 20) + 1
    }
    
    func wiper() {
        // 창문을 닦습니다.
    }
}

let trans: Vehicle = Car()
let car: Car = Vehicle() // Error!
```

설령 하위 클래스에서 추가로 정의하는 게 아무것도 없어도, 이 관계는 똑같이 적용된다. 상위 클래스 타입을 사용하는 이유는 인자값을 더 유연하게 받고, 집단 자료형도 유연하게 활용하는 등 다양한 객체를 활용하기 위해서이다.

### 타입 비교 연산.  is

스위프트에서는 타입 비교 연산자 is 를 지원한다. 연산자 왼쪽 인스턴스의 타입이 연산자 오른쪽 비교대상의 타입보다 같거나 낮으면(하위 클래스라는 뜻) true, 그외는 모두 두  false 이다. **연산자 양쪽에 어떤 게 위치하는지 헷갈리지 말자. 왼쪽은 인스턴스, 오른쪽은 일반적으로 타이비다.**

```swift
인스턴스(또는 변수, 상수) is 비교대상 타입
```

```swift
// SUV 클래스는 Car를 상속받음
SUV() is SUV // true
SUV() is Car // true
SUV() is Vehicle // true

Car() is Vehicle // true
Car() is SUV // false
```

주의할 점은, 변수나 상수 등으로 타입 비교를 할 때는 해당 변수의 타입이 아니라 실제 들어있는 인스턴스의 타입으로 비교한다는 점이다. 

```swift
let myCar: Vehicle = SUV()

if myCar is SUV {
  print("myCar는 SUV 타입입니다.")
} else {
  print("myCar는 SUV 타입이 아닙니다.")
}

// 실행결과
// myCar는 SUV 타입입니다.
```

## 업캐스팅, 다운캐스팅

캐스팅 개념은 다른 객체지향 언어와 비슷하다. 스위프트에서는 as라는 키워드를 사용하여 캐스팅을 지원한다. 이때 업캐스팅은 항상 안전하기 때문에 as 연산자의 반환값으로 바로 객체가 나오지만, 다운 캐스팅의 경우 오류가 발생할 가능성이 있기 때문에 옵셔널 캐스팅과 강제 캐스팅으로 나누어 진다.

보통 업캐스팅할 경우 추상화한다고 한다.

* 업캐스팅

  ```
  객체 as 변환할 타입
  ```

* 다운캐스팅

  ```
  객체 as? 변환할 타입(결과는 옵셔널 타입)
  객체 as! 변환할 타입(결과는 일반 타입)
  ```

다운 캐스팅의 경우 옵셔널 다루는 것과 마찬가지로 아래처럼 다루면 된다.

```swift
let anySUV = anyCar as? SUV
if anySUV != nil {
  print("\(anySUV!) 캐스팅이 성공하였습니다")
}
```

그래서 저자는 다음과 같이 축약해서 적는 걸 선호한다고 한다.

```swift
if let anySUV = anyCar as? SUV {
  print("\(anySUV) 캐스팅이 성공하였습니다.")
}
```

## AnyObject, Any

AnyObject는 마치 자바처럼, 최상위 클래스같은 친구다. 모든 클래스 인스턴스는 AnyObject 클래스 타입으로 선언된 변수나 상수에 할당할 수 있다. 이 타입으로 선언된 값은 항상 다운캐스팅만 되고 상속 관계가 성립하지 않아도 타입 캐스팅이 가능하다(그렇지만 실제 저장된 값과 관계가 없으면 오류가 발생하니 주의하자). AnyObject는 클래스에서만 사용할 수 있다(구조체, 열거형 X)

```swift
let obj: AnyObject = SUV()

if let suv = obj as? SUV {
  print("\(suv) 캐스팅이 성공하였습니다")
}
```

Any 객체도 AnyObject와 비슷하게 범용 객체이지만, 클래스 뿐만 아니라 스위트에 사용되는 모든 타입을 허용한다.편리하긴 하지만 Any 타입은 극단적으로 추상화된 것이기 때문에 Any 타입에 할당된 객체가 사용할 수 있는 프로퍼티나 메소드는 아예 제공되지 않는다. 또 동적으로 타입이 결정되니... 컴파일러가 오류를 잡기 힘들어서 오류가 오류를 뿜는, 생산성이 낮아지는 결과가 나타날 것이다(숨지마라! 자바스크립트!)

## 초기화 구문

모든 객체의 저장 프로퍼티는 인스턴스가 생성될 때 초기화되어 있어야한다. 모든 프로퍼티에 초기값이 설정되어 있다면 기본 초기화 구문(괄호만 붙인 것)으로 인스턴스를 생성할 수 있지. 

구조체는 추가적으로 멤버와이즈 초기화 구문이라고, 모든 저장 프로퍼티에 대해서 인자를 받고 초기화하는 구문이있다. 다른 초기화 구문은 직접 만들어야 해. 클래스는 멤버와이즈 초기화 구문이 없다.

초기화는 다른 객체지향 언어에서도 거의 유사한 개념이 등장하기 때문에 스위프트의 문법 위주로 보자.

## init 초기화 메소드

init 초기화 메소드 형식은 다음과 같다

```
init(<매개변수> : <타입>, <매개변수> : <타입>, ...) {
	1. 매개변수의 초기화
	2. 인스턴스 생성 시 기타 처리할 내용
}
```

초기화 구문에서 지켜야할 규칙은 4가지이며 그 외에는 일반 메소드의 특성을 따른다

> 1. 초기화 메소드의 이름은 init으로 통일
> 2. 매개변수의 개수, 이름, 타입은 임의로 정할 수 있다
> 3. 매개변수의 이름과 개수, 타입이 서로 다른 여러 개의 초기화 메소드를 정의할 수 있다(오버로딩 가능)
> 4. 정의된 초기화 메소드는 직접 호출되기도 하지만, 대부분 인스턴스 생성 시 간접적으로 호출된다

예시 코드를 보자. 예시코드에서 인스턴스 생성시 .init은 생략가능하다

```swift
struct Resolution {
    var width = 0
    var height = 0
    
    // 초기화 메소드 : width를 인자값으로 받음
    init(width: Int) {
        self.width = width
    }
}

class VideoMode {
    var resolution = Resolution(width: 2048)
    var interlaced = false
    var frameRate = 0.0
    var name: String?
    
    // 초기화 메소드 : interlaced, frameRate 두 개의 인자값을 받음
    init(interlaced: Bool, frameRate: Double) {
        self.interlaced = interlaced
        self.frameRate = frameRate
    }
}

// Resolution 구조체에 대한 인스턴스를 생성
let resolution = Resolution.init(width: 4096)

// VideoMode 클래스에 대한 인스턴스를 생성
let videoMode = VideoMode.init(interlaced: true, frameRate: 40.0)
```

근데 이렇게 init 메소드를 정의하면, 더이상 기본 초기화 구문을 사용할 수 없다. 그래서 예전처럼 기본 초기화 구문을 사용하려면, 아무 인자도 받지 않는 init 메소드를 정의해주어야 한다.

저자가 자주 사용하는 방식은, init도 메소드이니 매개변수에 기본값을 지정하여 기본 초기화 메소드를 정의한다고 한다. 이러면 매개변수를 생략할 수 있으니 기본 초기화 메소드를 사용할 수 있다. 예시 코드는 다음과 같다.

```swift
class VideoMode {
    var name: String?
    
    // 초기화 될 때 name 인자값을 받는 init 구문
    init(name: String = "") {
        self.name = name
    }
}

// VideoMode 클래스에 대한 인스턴스를 생성하고 상수에 할당
let defaultVideoMode = VideoMode() // 가능
let nameVideoMode = VideoMode(name: "홍길동") // 가능
```

init을 정의하면 더이상 기본 초기화 구문이 지원되지 않는 것은 구조체도 마찬가지니 주의하자(멤버와이즈도 컴파일러가 기본으로 주는 초기화 구문이니, 더이상 사용할 수 없다)

## 초기화 구문의 오버라이딩

메소드를 오버라이드 할 때는, 상위 클래스에서 정의되지 않은 경우 override 키워드를 붙이면 안되지만, **기본 초기화 구문 init()은 부모 클래스에서 명시적으로 선언된 적이 없더라도 이를 상속받은 자식 클래스에서 반드시 오버라이딩 형식으로 작성해야 한다.** 

```swift
class Base {
}

class ExBase: Base {
	override init() {
	
	}
}
```

ExBase 클래스에서 명시적으로 기본 초기화 메소드를 작성하려면, Base에서 정의된 적은 없지만 override 키워드를 붙여줘야 하는 것.

메소드와 다르게 초기화 구문에서 오버라이딩을 할경우 더 이상 부모 클래스에서 정의한 초기화 구문이 실행되지 않아서 문제가 생길 수 있다. 프로퍼티가 초기화되지 못하는 상황은 오류가 발생하니 이런 상황을 방지하고자 초기화 구문을 오버라이딩할 경우 오버라이딩한 부모의 초기화 구문을 명시적으로 호출해줘야 한다. 바로 super.init 구문을 적어서.

```swift
class Base {
    var baseValue: Double = 10.0
  init(inputValue: Double) {
    self.baseValue = inputValue
  }
}

class ExBase: Base {
    override init(inputValue: Double) {
        super.init(inputValue: 10.5)
    }
}
```

직접 해보니, 오버라이딩한 초기화 구문에서는 반드시 super.init 구문을 작성해주어야 한다. 안 그러면 컴파일러가 오류 뿜는다.

일반 메소드랑 똑같아. override 할 수 있는 초기화 구문이 있어야만 override가 가능하고(부모 클래스가 기본 초기화 구문 없이 다른 초기화만 정의했으면 기본 초기화 구문이 없으니, init() 오버라이딩은 할 수 없다), 객체 초기화니 이에 맞게 super로 초기화 구문 호출해줘야 하는 거지. 기본 초기화 구문이 있으면 알아서 호출되니 super 안해도 되지만 그게 아니면 super 해줘야하는 거고.

## 초기화 구문 델리게이션(Initializer Delegation)

연쇄적으로 오버라이딩된 자식 클래스의 초기화 구문에서 부모 클래스의 초기화 구문에 대한 호출이 발생하는 것을 초기화 구문 델리게이션이라고 한다.

**자식부터 부모까지 역순으로 초기화가 이루어지고, super.init 구문을 안 적어도 되는 경우는 기본 초기화 구문을 컴파일러가 호출할 수 있을 때만 그렇다. 뭐 부모 클래스가 기본 초기화 구문만 있는 경우만?. 기본 초기화에 더해서 다른 초기화도 있다면 기본 초기화까지 명시적으로 호출해야한다.** 

```swift
class Base {
    var baseValue: Double
    
    init() {
        self.baseValue = 0.0
        print("Base Init")
    }
    
    init(baseValue: Double) {
        self.baseValue = baseValue
    }
}

class ExBase: Base {
    override init() {
        super.init()
        print("ExBase Init")
    }
}
```

## 옵셔널 체인

옵셔널 객체가 있으면 그동안 두 가지 방법으로 옵셔널을 해제했다. if문으로 nil인지를 확인하고 강제 해제하든지, 아니면 옵셔널 비강제 해제 구문을 사용해서 값을 꺼내오던지. 그런데 만약에 객체가 옵셔널이고, 객체 내의 저장 프로퍼티가 옵셔널 객체고, 이게 꼬리에 꼬리를 문다면? 매번 nil을 검사하고 해제하고 검사하고 해제하고 그래야할까? 이렇게 되면 실제로 구현해야 하는 논리 흐름에 집중하기 보다는 오류를 차단하기 위한 코드를 더 많이 작성해야 하게 되고 코드가 길어지게 된다. 이런 옵셔널의 단점을 극복하고 복잡한 코드를 간단하게 줄여주는 방법으로 도입된 것이 옵셔널 체인이다.

```swift
struct Human {
    var name: String?
    var man: Bool = true
}

struct Company {
    var ceo: Human?
    var companyName: String?
}

var startup: Company? = Company(ceo: Human(name: "니대표", man: false), companyName: "루비페이퍼")

// 옵셔널이 많아지면 두 가지 단점이 생기지
// 1. 하나씩 nil 인지를 확인하자니 너무 길고
if let company = startup {
    if let ceo = company.ceo {
        if let name = ceo.name {
            print("대표이사의 이름은 \(name) 입니다.")
        }
    }
}

// 2. 바로 다 강제 해제하기에는 오류가 날수도 있고
if let name = startup!.ceo!.name {
    print("대표이사의 이름은 \(name) 입니다.")
}
```

옵셔널 체인(Optional Chain)은 옵셔널 타입으로 정의된 값이 하위 프로퍼티나 메소드를 가지고 있을 때, 이 요소들을 if 구문을 쓰지 않고도 간결하게 사용할 수 있는 코드를 작성하기 위해 도입되었다.

다른 일반적인 객체지향에서는(자바 등) 존재하지 않는 객체의 메소드나 프로퍼티를 호출하면 바로 NullPointException이 발생할 것이다. 오브젝티브-C에서는 nil인 객체의 메소드나 프로퍼티를 호출해도 아무 오류가 발생하지 않는 것에 비해.

옵셔널 체인은 다음과 같이 사용할 수 있다.

```swift
startup?.ceo
```

만약 startup 에 nil이 할당되어 있더라도 잘못된 참조에 의한 오류는 발생하지 않는다. 그저 아무일도 일어나지 않을 뿐. 그래서 위의 복잡한 코드가 아래처럼 줄어든다

```swift
if let name = startup?.ceo?.name {
  print("대표이사의 이름은 \(name)입니다.")
}
```

그리고 옵셔널 체인에는 다음과 같은 특징이 있다.

>1. **옵셔널 체인으로 참조된 값은 무조건 옵셔널 타입으로 반환된다.**
>2. **옵셔널 체인 과정에서 옵셔널 타입들이 여러 번 겹쳐 있더라도 중첩되지 않고 한 번만 처리된다.**

1의 경우를 생각해보자. startup?.ceo?.man 을 참조하더라도(옵셔널 타입이 아닌 프로퍼티임) 반드시 옵셔널 타입으로 반환된다는 뜻이다. 왜냐하면 옵셔널 체인을 사용한다는 것 자체가 nil을 반환할 가능성을 내포하고 있기 때문이다. 반환 타입은 항상 반환이 가능한 모든 타입을 포함할 수 있는 자료형이고 nil 이 반환될 가능성이 있으니깐 당연한 내용이다.

2의 경우를 생각해보자. 옵셔널 타입은 결국 옵셔널이 아무리 중복되더라도 결국 반환할 수 있는 값은 nil 또는 정상값 두 개로 나뉘어지므로 단순히 하나의 옵셔널 객체로 감싼 값이 된다.

```swift
// 양쪽은 똑같지
Optional(Optional(Optional(123))) = Optional(123)
```

옵셔널 메소드의 결과값도 메소드 체인으로 이어줄 수 있다(메소드 반환값이 옵셔널이라면). 이 경우는 메소드 자체를 옵셔널 체인으로 사용하는 것과 다르다(메소드 자체를 옵셔널로 사용하려면 옵셔널 메소드일 때만 가능함. 프로토콜에서 이 내용을 다룰 것임).

그래서 옵셔널 체인 구문과 강제 해제 구문을 비교하면 아래와 같다

> * 옵셔널 체인 구문: someCompany?.getCEO()?.name
> * 옵셔널 강제 해제: someCompany!.getCEO()!.name

옵셔널 객체가 반드시 nil이 아니라고 확신할 수 있다면 옵셔널 강제 해제 구문을 써서 간단하게 코드를 줄여서 쓰겠지만, 옵셔널 체인 구문도 그에 못지 않게 간결한 구문으로 필요한 코드를 작성할 수 있다. 