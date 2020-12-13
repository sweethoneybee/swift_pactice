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