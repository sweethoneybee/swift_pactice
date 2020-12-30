# 프로토콜

오브젝티브-C에서도 프로토콜 개념은 사용되었는데, 클래스나 구조체가 어떤 기준을 만족하거나 또는 특수한 목적을 달성하기 위해 구현해야하는 메소드와 프로퍼티의 목록들이다.

iOS는 Delegate Pattern을 많이 사용하는데 이 패턴을 구현하기 위해 이용되는 것이 프로토콜이다. 

프로토콜에 선언된 프로퍼티나 메소드의 형식을 '명세'라고 부르고, 그것에 맞추어 실질적인 내용을 작성하는 것을 '구현(implement)한다'라고 한다.

상속과 다르게 프로토콜은 횡적인 개념이다. 부모 클래스를 상속받아 기능을 구현하는 것은 종적인 개념이다. **프로토콜은 대상 클래스 전체를 책임지지 않으며, 단지 한 부분 또는 몇 가지 기능의 형식만을 담당한다.**

## 프로토콜의 정의

스위프트에서 프로토콜을 구현할 수 있는 구현체들은 구조체, 클래스, 열거형, 익스텐션이다. 프로토콜 정의와 구현을 위한 구문은 다음과 같다.

```swift
// protocol 선언
protocol <프로토콜 명> {
  <구현해야할 프로토콜 명세1>
  <구현해야할 프로토콜 명세2> ...
}

struct/class/enum/extension 객체명: 구현할 프로토콜 명 {
  
}
```

### 프로토콜 프로퍼티

프로토콜에 선언되는 프로퍼티는 초기값을 할당할 수 없어서 저장, 연산을 구분하지 않는다. (다만 읽기가 가능한지, 쓰기가 가능한지, 읽기쓰기가 둘다 가능한지를 구분함). 프로퍼티의 종류, 이름, 변수/상수 구분, 타입, 읽기 전용 혹은 읽고 쓰기인지만 정의한다.  그 정의에 맞추어서만 프로퍼티를 구현해주면 된다. 예를 들어 읽기쓰기가 둘다 가능한 프로퍼티 명세라면 저장 프로퍼티 혹은 get, set이 된 연산 프로퍼티로 구현할 수 있겠다. 읽기만 가능하다면 get 만 가진 연산 프로퍼티로 구현할 수 있겠다.

```swift
protocol SomePropertyProtocol {
    var name: String { get set } // 읽고 쓰기 가능
    var description: String { get } // 읽기만 가능
}

struct RubyMember: SomePropertyProtocol {
    var name = "홍길동"
    var description: String {
        return "Name: \(self.name)"
    }
}
```

프로토콜에 명시되어있는 프로퍼티만 다 구현하면, 프로퍼티를 추가하는 건 얼마든지 가능하다.

### 프로토콜 메소드

프로토콜에 선언되는 메소드도 프로퍼티와 유사하다. 그냥 평소 메소드 정의하듯이 하되, 정의부분만 남겨두고 중괄호 블록만 빼면된다. 프로토콜과 일치시켜야하는 매개변수명은 외부로 드러나는 매개변수명만 일치시키면 된다. 그래서 외부 매개변수명만 일치시키면 내부 매개변수명은 맘대로 해서 구현해도 된다는 의미(프로토콜 메소드에 매개변수가 하나만 있으면 그걸로 외부 매개변수 설정하고 내부 매개변수 만들어서 처리해도 된다.). 아무튼 명세대로 구현하고 쓸 수 있게만 하면 된다는 거지.

```swift
protocol SomeMethodProtocol {
    func execute(cmd: String)
    func showPort(p: Int) -> String
}

struct RubyService: SomeMethodProtocol {
    func execute(cmd: String) {
        if cmd == "start" {
            print("실행합니다.")
        }
    }
    
    func showPort(p: Int) -> String {
        return "Port: \(p)"
    }
}
```

```swift
protocol NewMethodProtocol {
    mutating func execute(cmd command: String, desc: String)
    func showPort(p: Int, memo desc: String) -> String
}

struct RubyNewService: NewMethodProtocol {
    func execute(cmd command: String, desc: String) {
        if command == "start" {
            print("\(desc)를 실행합니다.")
        }
    }
    
    func showPort(p: Int, memo d:String) -> String {
        return "Port: \(p). Memo: \(d)"
    }
}
```

### 프로토콜에서의 mutating, static 사용

클래스는 해당되지 않지만, 구조체나 열거형 내의 메소드가 프로퍼티를 변경하는 경우 메소드 앞에 반드시 mutating 키워드를 붙여야 한다. 근데 이 메소드가 프로토콜에서 선언된 메소드라면, 프로토콜에서도 mutating 키워드가 붙어있어야 한다. 만약에 프로토콜에 mutating 키워드가 붙어있지 않는데 구현할 때 억지로 붙여서 구현하면, 컴파일러는 프로토콜에서 구현해야할 것을 빼먹었다고 오류를 뿜을 것이다.

이런 면에서, 프로토콜은 자신을 구현하는 구조체가 마음대로 프로퍼티를 수정하지 못하도록 통제할 수 있는 권한을 가지고 있다. 그래서 일반적으로 프로토콜에서 메소드 선언에 mutating 키워드가 붙지 않는 것은 다음 두 가지 중 하나로 해석할 수 있다.

> 1. 구조체나 열거형 등 값 타입의 객체에서 내부 프로퍼티의 값을 변경하기를 원치 않을 때
> 2. 주로 클래스를 대상으로 간주하고 작성된 프로토콜일 때

프로토콜에 mutating 키워드가 붙어있어도 실제로 구현할 때 프로퍼티를 수정하지 않아서 mutating 키워드를 떼고 구현해도 오류를 뿜지 않는다. 또한 클래스는 어차피 mutating 키워드를 안 쓰기 때문에 붙은 거 신경 안쓰고 메소드 구현해도 된다.

타입 메소드나 타입 프로퍼티도 프로토콜에서 정의할 수 있다. 단, class 키워드는 사용할 수 없다(구조체랑 열거형은 이거 안쓰거든). 그래서 프로토콜 선언할 때는 static 키워드로만 타입 메소드, 프로퍼티를 정의할 수 있고 대신에 실제 구현할 때는 class 키워드를 사용해서 구현해도 된다.

### 프로토콜과 초기화 메소드

프로토콜에서는 초기화 메소드도 정의할 수 있는데 앞서 본 일반 메소드랑 거의 비슷하다. 근데 기본으로 제공되는 메소드(기본 초기화 메소드, 멤버와이즈 메소드 같은 것)이 정의되어있을 경우, 기본 제공 여부에 관계없이 모두 직접 구현해 주어야 한다. 또 클래스에서 초기화 메소드를 구현할 때는 required 키워드를 반드시 붙여야한다.

```swift
protocol SomeInitProtocol {
    init()
    init(cmd: String)
}

struct SInit: SomeInitProtocol {
    var cmd: String
    
    init() {
        self.cmd = "start"
    }
    
    init(cmd: String) {
        self.cmd = cmd
    }
}

class CInit: SomeInitProtocol {
    var cmd: String
    
    required init() {
        self.cmd = "start"
    }
    
    required init(cmd: String) {
        self.cmd = cmd
    }
}
```

클래스는 상속과 프로토콜 구현이 동시에 가능한 객체이기 때문에 초기화 메소드를 상속받으면서 동시에 구현해야할 때가 있다(똑같은 메소드가 정의되어 있어서 충돌이 나는 것). 이때는 상속을 받아서 메소드가 있더라도, 프로토콜 명세에 동일한 초기화 메소드가 선언되어 있다면 이를 다시 구현해야한다. 이걸 부모 클래스 관점에서 보면 상속받은 초기화 메소드를 오버라이드하는 셈이다. 그래서 (순서와 관계없이) override, required 키워드를 둘다 붙여줘야한다.

```swift
protocol Init {
    init()
}

class Parent {
    init() {
        
    }
}

class Child: Parent, Init {
    override required init() {
        
    }
}

```

## 타입으로서의 프로토콜

프로토콜 그 자체로는 객체 생성을 할 수 없고 할 수 있는 일이 거의 없지만, 얘는 타입으로 사용될 수 있다. 마치 우리가 업캐스팅으로 상수나 변수를 저장하듯이 동일하게 프로토콜을 사용할 수 있다.

```swift
protocol Wheel {
    func spin()
    func hold()
}

class Bicycle: Wheel {
    var moveState = false
    
    func spin() {
        self.pedal()
    }
    
    func hold() {
        self.pullBreak()
    }
    
    func pedal() {
        self.moveState = true
    }
    
    func pullBreak() {
        self.moveState = false
    }
}

let trans: Wheel = Bicycle()
trans.spin()
trans.hold()
```

프로토콜 타입으로 선언한 변수나 상수의 객체는 프로토콜에 정의되어있는 메소드, 프로퍼티에 대해서는 보장을 받으니(프로토콜을 구현한 객체는 반드시 그 내용을 구현했으니깐!) 사용할 수 있는 것이다.

그런데, 상황에 따라서는 프로토콜을 두 개 이상 구현할 때가 있는데 그에 대한 예시는 다음과 같다.

```swift
protocol A {
    func doA()
}

protocol B {
    func doB()
}

class Impl: A, B {
    func doA() {
        
    }
    
    func doB() {
        
    }
    
    func desc() -> String {
        return "Class instance method"
    }
}

var ipl: A & B = Imple()
ipl.doA()
ipl.doB()
// ipl.desc() 불가능. A & B 타입 변수이기 때문
```

& 연산자를 통해서 두 개 이상의 프로토콜의 타입을 표현할 수 있다.

## 델리게이션

프로토콜 타입으로 선언된 값을 사용한다는 것은, 여기에 할당된 객체가 구체적으로 어떤 기능을 갖추고 있는지는 상관 없다는 뜻이기도 하다. 그저 단순히 할당된 객체를 사용하여 프로토콜에 정의된 프로퍼티나 메소드를 호출하겠다는 의미가 된다.

코코아 터치 프레임워크에서는 이러한 프로토콜 타입의 특성을 이용하여 델리게이션이라는 기능을 구현한다.

델리게이션(Delegation)은 델리게이트 패턴과 연관되는 아주 중요한 개념으로, 간략히 설명하자면 특정기능을 다른 객체에 위임하고, 그에 따라 필요한 시점에서 메소드의 호출만 받는 패턴이라고 할 수 있다.

```swift
protocol FuelPumpDelgate {
    func lackFuel()
    func fullFuel()
}

class FuelPump {
    var maxGage: Double = 100.0
    var delegate: FuelPumpDelgate? = nil
    
    var fuelGage: Double {
        didSet {
            if oldValue < 10 {
                // 연료가 부족해지면 델리게이트의 lackFule 메소드를 호출한다.
                self.delegate?.lackFuel()
            } else if oldValue == self.maxGage {
                // 연료가 가득차면 델리게이트의 fullFuel 메소드를 호출한다.
                self.delegate?.fullFuel()
            }
        }
    }
    
    init(fuelGage: Double = 0) {
        self.fuelGage = fuelGage
    }
    
    // 연료펌프를 가동한다
    func startPump() {
        while (true) {
            if(self.fuelGage > 0) {
                self.jetFuel()
            } else {
                break
            }
        }
    }
    
    // 연료를 엔진에 분사한다. 분사할 때마다 연료 게이지의 눈금은 내려간다.
    func jetFuel() {
        self.fuelGage -= 1
    }
}

class Car: FuelPumpDelgate {
    var fuelPump = FuelPump(fuelGage: 100)
    
    // 여기를 눈여겨 봐두자
    init() {
        self.fuelPump.delegate = self
    }
    
    // fuelPump가 호출하는 메소드입니다.
    func lackFuel() {
        // 연료를 보충한다.
    }
        
    // fuelPump가 호출하는 메소드입니다.
    func fullFuel() {
       // 연로 보충을 중단한다.
    }
    
    // 자동차에 시동을 겁니다.
    func start() {
        fuelPump.startPump()
    }
}
```

부모 클래스를 쓰는 경우, 클래스는 단일 상속만을 지원하기 때문에 기능을 덧붙이기에 제한적이다. 이를 극복하기 위해 구현 개수에 제한이 없는 프로토콜을 이용하여 필요한 기능 단위별 객체를 작성하는 것이다.

## 프로토콜의 활용

### 확장 구문과 프로토콜

본래의 객체에서 프로토콜을 구현하지 않더라도 익스텐션에서 프로토콜을 구현하는 경우 이후로 해당 객체는 프로토콜을 구현한 것으로 처리된다.

```swift
class Man {
    var name: String?
    
    init(name: String = "홍길동") {
        self.name = name
    }
}

protocol Job {
    func doWork()
}

extension Man: Job {
    func doWork() {
        print("\(self.name!)님이 일을합니다.")
    }
}

let man = Man(name: "개발자")
man.doWork()
```

추가로 주의할 점은, 익스텐션에서는 저장 프로퍼티를 정의할 수 없으니 프로토콜에서 정의된 프로퍼티를 구현할 때는 연산 프로퍼티로 구현해줘야 한다.

### 프로토콜의 상속

프로토콜은 프로토콜끼리 상속하여 프로퍼티, 메소드, 초기화 블록을 물려줄 수 있다. 클래스와는 다르게 다중 상속이 가능하다. 그래서 여러 개의 프로토콜을 하나의 프로토콜에 한꺼번에 상속하여 각 프로토콜들의 명세를 하나의 프로토콜에 담을 수 있다.

```swift
protocol A {
    func doA()
}

protocol B {
    func doB()
}

protocol C: A, B {
    func doC()
}

class ABC: C {
    func doA() {
        
    }
    
    func doB() {
        
    }
    
    func doC() {
        
    }
}

let abc: C = ABC()
// abc.doA(), abc.doB(), abc.doC()

let a: A = ABC()
// a.doA()

let ab: A & B = ABC()
// ab.doA(), ab.doB()

let abc2: A & B & C = ABC()
// abc2.doA(), abc2.doB(), abc2.doC()
```

프로토콜에서는 상속받을 때 동일한 메소드 선언이 있어도 override 키워드를 붙여야할 제약조건이 없다.

이렇게 다중 상속한 프로토콜을 구현하면, 상속한 다른 프로토콜을 구현한 것으로 대우받을 수 있게 된다. 그래서 정의할 때 타입이나, 타입검사(is), 캐스팅(as)도 다 가능하게 된다.

```swift
abc is C // true
abc is A & B // true
abc is A // true
abc is B // true
abc is B // true
a is C // true
a is B // true
ab is C // true
abc2 is A & B & C // true
```

### 클래스 전용 프로토콜

클래스만 구현할 수 있는 프로토콜로 정의할 수 있다. class 키워드를 사용하면 되는데, 이때 상속받는 다른 프로토콜이 있는 경우 맨 앞에 class 키워드를 붙여주기만 하면 된다. 당연히 클래스 내에서만 쓰이는 프로토콜이기 때문에 mutating 키워드를 쓸 수 없고 대신 static 키워드는 제약없이 사용할 수 있다.

```swift
protocol SomeClassOnlyProtocol: class, Wheel, Machine {
    // 클래스에서 구현할 내용 작성
}
```

### optional

프로토콜에 명시된 요소들은 모두 반드시 구현해야하는데, 구현하는 객체에 따라 특별히 필요하지 않은 프로퍼티나 메소드, 초기화 구문이 있을 수 있다. 이런 것까지 다 필수로 구현하다보면 상당히 번거로워지고 무의미한 코드가 늘어나게 될 것이다

이 경우 선택적으로 구현할 수 있도록 선택적 요청(Optional Requirement)라는 문법이 있다. 프로토콜을 정의할 때 optional 키워드를 사용하여 프로퍼티, 메소드, 초기화 구문 앞에 표시하면 프로토콜을 구현할 때 반드시 구현하지 않아도 된다.

그런데 프로토컬에서 optional 키워드를 사용하려면 제약이 있다. 프로토콜 앞에 @objc를 표시해야한다. @objc는 파운데이션 프레임워크에 정의된 어노테이션의 일종으로서, 이 어노테이션이 붙은 코드나 객체를 오브젝티브-C에서도 참조할 수 있도록 노출됨을 의미한다. 실제로 우리가 정의한 프로토콜이 오브젝티브-C 코드와 상호 동작할 일이 없어도 그렇다. 또 @objc 어노테이션이 붙은 프로토콜은 구조체나 열거형 등에서 구현할 수 없고 오직 클래스만 이 프로토콜을 구현할 수 있다.

달리 말하면 optional 키워드가 붙은 선택적 요청 프로토콜은 클래스만 구현할 수 있다.

```swift
import Foundation

@objc
protocol MsgDelegate {
    @objc optional func onReceive(new: Int)
}

class MsgCenter {
    var delegate: MsgDelegate?
    var newMsg: Int = 0
    
    func msgCheck() {
        if newMsg > 0 {
            self.delegate?.onReceive?(new: self.newMsg)
            self.newMsg = 0
        }
    }
}

class Watch: MsgDelegate {
    var msgCenter: MsgCenter?
    
    init(msgCenter: MsgCenter) {
        self.msgCenter = msgCenter
    }
    
    func onReceive(new: Int) {
        print("\(new) 건의 메세지가 도착했습니다.")
    }
}
```

눈여겨봐야하는 메소드는 바로 onReceive(new:) 메소드이다. 이 메소드는 optional 키워드가 붙어있기 때문에 필수로 구현할 필요가 없다. 그래서 호출할 때도 옵셔널 체인처럼 사용한다. 주의할 점은 메소드 결과값이 옵셔널이 아니라 메소드 자체가 옵셔널이니 메소드와 괄호 사이에 ? 연산자를 작성해야한다(물론 !도 가능하겠지. 확신이 있다면)

> .onReceive?(new: self.newMsg)

Watch 클래스에서는 onReceive(new:) 메소드를 구현하지 않아도 된다. 단지 구현하지 않으면 새로 온 메시지를 확인하지 못할 뿐이다.

실제로 코코아 터치 프레임워크에서는 프로토콜마다 정의해야 할 메소드가 상당히 많다. 매우 디테일한 앱을 만들어야 한다면 이들 메소드 대부분을 구현해야하지만 메소드 중 일부만을 사용해야 할 경우라면 모든 메소드를 구현하는 건 큰 부담이다. 그래서 해당 프로토콜에서 반드시 필요한 메소드들만을 제외하고 나머지는 optional 키워드로 선언해두어서 선택적으로 구현할 수 있도록 제공한다.