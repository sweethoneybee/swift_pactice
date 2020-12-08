# Function

스위프트 함수의 기본적인 형태

```swift
func printHello() {
    print("Hello")
}

func sayHello() -> String {
    let retValue = "Hello"
    return retValue
}

func printHelloWithName(name: String) {
    print("Hello, \(name)")
}

func sayHelloWithName(name: String) -> String {
    let retValue = "Hello, \(name)"
    return retValue
}

```

스위프트는 Object C와의 호환성을 위해 인자에 label을 붙이고 있다(라벨 붙였다가, 일부만 허용하다가, 오픈소스로 전환된 뒤로 통일성을 위해 모든 인자에 다 라벨을 붙이는 걸로 / 코코아 터치 프레임워크의 호환성을 많이 고려한 문법인듯). 좋은지는 글쎄..?

스위프트는 라벨이 다르면 다른 함수 취급을 한다. 그래서 함수의 이름은 라벨까지 포함해서 말한다. 

```swift
func incrementBy(amount: Int, numberOfTimes: Int) {
  var count = 0
  count = amount * numberOfTimes
}
```

위의 경우 함수의 이름은 `incrementBy(amount:numberOfTimes:)` 이다. 콜론(:) 까지 이름에 포함되는 것에 주의하자. 

근데 저자분의 말로는, 함수의 이름보다는 식별자(Signature)로 보는 것이 더 타당하다고 한다. 우리가 일반적으로 아는 것처럼 func 키워드 뒤에 들어가는 것이 함수명이고, 여기에 인자 레이블을 포함한 것을 함수의 식별자로 본다는 것.

이는 다음과 같은 호출구문이 성립하는 것을 보면 알 수 있다.

```swift
func times(x: Int, y: Int) -> Int {
    return (x * y)
}

times(x: 5, y: 10) // 함수의 이름만으로 호출한 구문
times(x:y:)(5, 10) // 함수의 식별자를 사용하여 호출한 구문
```

스위프트에서 함수를 호출하는 방법은 **함수명 + 괄호 + 인자값**이므로인자 레이블까지를 전체 함수의 이름으로 본다면 항상 times(x:y:)(5, 10) 형식으로 호출하는 것이 맞을 것이다. 하지만 실제로는 times만으로 함수를 호출할 수 있다. 그러니 times는 함수의 이름으로, times(x:y:)는 함수의 식별자로 보는 것이 조금 더 적절하다.

주의할 점은 지금은 매개변수명이 곧 함수 식별자의 일부가 되는 것처럼 보이지만, 실제로는 인자 레이블 역할을 하는 매개변수만 함수 식별자에 포함된다ㅣ는 점이다. 스위프트에서는 인자 레이블 역할을 하지 않는 매개변수가 등장하기도 하고, 인자 레이블과 매개변수가 분리되가도 한다고 한다. 또한 인자 레이블의 변경 때문에 함수의 식별자가 달라지기도 한다. 정리하면, 함수의 식별자에 포함되는 것은 인자 레이블일 뿐, 결코 매개변수가 아니다.

## 함수 반환과 튜플

함수 반환할 때 튜플을 사용할 수 있음.

```swift
func getUserInfo() -> (Int, Character, String) {
    let gender: Character = "M"
    let height = 180
    let name = "꼼꼼한 성훈이"
    
    return (height, gender, name)
}

var uInfo = getUserInfo()
uInfo.0 // 180
uInfo.1 // "M"
uInfo.2 // "꼼꼼한 성훈이"
var (a, b, c) = getUserInfo()
a // 180
b // "M"
c // "꼼꼼한 성훈이"
```

특이한 점은 반환 튜플값에 미리 변수를 할당하면 결과값을 받은 변수에도 이게 자동으로 바인딩 된다.

```swift
func getUserInfo2() -> (h: Int, g: Character, n: String) {
    let gender: Character = "M"
    let height = 180
    let name = "꼼꼼한 성훈이"
    
    return (height, gender, name)
}

var result = getUserInfo2()
result.h // 180
result.g // "M"
result.n // "꼼꼼한 성훈이"
```

### 타입 알리어스(typealias)

특정 튜플 타입이 여러 곳에서 사용될 경우 타입 알리어스를 통해 새로운 축약형 타입을 정의하는 것이 좋다. 

```swift
typealias infoResult = (Int, Character, String)

func getUserInfo() -> infoResult {
    let height = 180
    let gender: Character = "M"
    let name = "꼼꼼한 성훈이"
    
    return (height, gender, name)
}

let info = getUserInfo()
info.0 // 180
info.1 // "M"
info.2 // "꼼꼼한 성훈이"
```

타입 알리어스를 사용하면 길고 복잡한 형태의 타입 표현도 짧게 줄일 수 있어 전체적으로 소스코드가 간결해지는 효과를 가져올 수 있다. 단, 타입 알리어스는 어디까지나 타입에 대한 새로운 표현을 정의하는 역할을 하기 때문에 타입이 아닌 구체적인 값을 상수처럼 사용할 수는 없다.

## 매개변수

### 외부 매개변수, 내부 매개변수 

스위프트에는 외부 매개변수와 내부 매개변수가 있다. 일단은 매개변수명이 외부와 내부에서 의미가 달라질 수 있다는 점, 내부 매개변수명이 너무 긴 경우 함수 호출 시 번거로운 점(외부 매개변수 명이 곧 함수의 이름에도 포함됨) 때문이다. 하지만 사실은 오브젝트-C와의 호환성이 가장 큰 목적일 것이다.

형태는 다음과 같다.

```
func 함수이름(<외부 매개변수명> <내부 매개변수명>: <타입>...) {

}
```

그리고 외부 매개변수는 언더바(_)로 생략이 가능하여 생략한 경우 함수 호출시에 라벨을 안 붙여도 된다. 아래의 형태처럼 맨 앞의 매개변수를 생략한 이 구조는 코코아 터치 프레임워크에서 굉장히 많이 사용되는 방식이다(오브젝트-C에서는 첫 번째 매개변수 라벨을 생략 가능하니깐!)

```swift
func printHello(_ name: String, welcomeMessage msg: String) {
	print(msg + ", " + name)
}
printHello("Jeong", welcomeMessage: "Hello")

```

이렇게 외부 매개변수명을 언더바로 했으니 함수명에도 역시 언더바를 넣어 표시해야한다. 

`printHello(_:welcomeMessage:)`

### 가변인자

파이썬에서 * 기호를 통해 가변인자를 받고 리스트 형태로 함수 내부에서 사용할 수 있듯이, 스위프트에서는 함수를 정의할 때 매개변수명 다음에 '...' 연산자를 추가함으로써 가변인자를 받을 수 있다. 또한 이 가변 인자는 배열로 처리하기에 for~in 구문으로 모든 인자값을 순서대로 읽어들일 수 있다.

```swift
func avg(score: Int...) -> Double {
    var total = 0
    for r in score {
        total += r
    }
    return (Double(total) / Double(score.count))
}

print(avg(score: 10,20,30,40))

```

### 기본값을 갖는 매개변수

다른 언어들과 마찬가지로 매개변수에 기본값을 넣을 수 있다.

```swift
func echo(message: String, newLine: Bool = true) {
    if newLine == true {
        print(message, true)
    } else {
        print(message, false)
    }
}

echo(message: "안녕하세요")
echo(message: "안녕하세요", newLine: false)
```

### 매개변수의 수정 - 매개상수

스위프트에서 매개변수는 사실 상수(let)으로 전달되었다. 다음의 코드는 오류가 난다.

```swift
func incrementBy(base: Int) -> Int {
    base += 1
    return base
}
// error: MyPlayground.playground:2:10: error: left side of mutating operator isn't mutable: 'base' is a 'let' constant
```

함수에 값을 전달할 때, 변수를 인자로 대입할 때도 마찬가지로 실제로는 값의 복사를 통해서 상수가 새로 정의된 다음 전달된다. 복사값이 전달되는 것이다. 함수에 입력된 인자값은 함수 내부에서 항상 상수로 정의된다.

그래서 스위프트에서는, 매개상수 이름과 같은 매개변수를 작성하고 값을 대입하면 이제 값을 수정하는 구문을 쓸 수 있다(당연하게도...)

```swift
func incrementBy(base: Int) -> Int {
    var base = base
    base += 1
    return base
}
incrementBy(3) // 4
```

### InOut 매개변수

inout 키워드를 통해서 인자 자체를 전달해줄 수 있다. 마치 C에서 포인터처럼. 그래서 인자를 전달할 때도 & 연산자를 붙여줘야 한다. 즉 값이 아니라 주소를 전달해주는 것.

````swift
var cnt: Int = 30

func autoIncrement(value: inout Int) -> Int {
    value += 1
    
    return value
}

print(autoIncrement(value: &cnt)) // 31
print(cnt) // 31
````

&를 붙인 변수는 주소를 전달하게 되고(주소 추출 연산자), 이 주소를 읽어들이기 위해 함수에서 매개변수에 inout 키워드가 추가되는 것.

다른 언어에서도 보이던 **참조에 의한 전달** 이다. 추가로 상수를 전달해보려 했지만 immutable한 값은 inout argument로 전달할 수 없다는 에러가 발생한다.

```swift 
let cnt: Int = 30

func autoIncrement(value: inout Int) -> Int {
    value += 1
    
    return value
}

print(autoIncrement(value: &cnt))
print(cnt)
// error: MyPlayground.playground:9:28: error: cannot pass immutable value as inout argument: 'cnt' is a 'let' constant
```

### 참조에 의한 전달

스위프트에서 기본 자료형 String, Int, Double, Float, Bool 등 대부분은 값에 의한 전달 방식으로 인자값을 전달한다(Call By Value). 반면 inout 키워드와 & 연산자를 이용해서 주소를 전달할 수 있게된다(Call By Reference).

눈여겨 봐야할 점은, **예외적으로 Class로 구현된 인스턴스는 inout 키워드를 사용하지 않아도 항상 참조에 의해 전달**된다. 이것만 잘 기억하면 될 듯.

inout 키워드가 붙은 매개변수에 인자값을 입력할 때는 함수 내부에서 원본 객체를 수정할 수 있게되기 때문에 상수(let), 리터럴은 전달할 수 없다. 오직 변수만 인자로 사용 가능하다.

### 변수 생존 범위와 생명 주기

다른 언어와 마찬가지로 **스코프(Scope)** 로 생존 범위가 결정된다. if 구문이나 guard, for~in, 함수 등 중괄호 { }를 이용하여 실행 블록을 갖는 모든 구문들은 블록을 만들어내는 대상.

```swift
do {
    var ccnt = 0
    do {
        ccnt = 3
        print(ccnt)
    }
    ccnt += 1
    print(ccnt)
}
```

(오류는 아니지만 눈여겨봐야할 내용). 위의 코드를 보자. 바깥 범위에서 변수를 선언하고(ccnt) 초기화를 빼먹지 않아야한다고 한다. 변수가 생성된 블록이 아닌 다른 블록에서 사용하려면 반드시 초기화되어 있어야 한다. 자세이 뜯어보면 상위블록에서 하위블록으로 참조에 의한 전달 과정이 일어나는 것이기에 변수를 위한 주소값이 필요한 것이다. 변수가 초기화되지 않았다면 메모리를 할당받지 못한 상태이므로 주소값도 존재하지 않는다. 따라서 오류가 발생한다. -> 아니 근데 Playground에서는 오류 안나던데 흠. 그리고 내가 원래 생각하던 개념은 변수를 선언한 순간에 공간을 배정받는 거 아닌가? 음....... 이게 아닌가보네. 변수를 선언한 순간에는 공간은 아직 배정 안되나 보다. 책에서 알려준대로 생각하자. 변수를 선언했을 때는 공간 할당 X. 

나머지 내용은 다른 언어와 유사하다. 변수의 생명주기, 글로벌 변수는 함수 내부에서 참조 가능, 전역과 지역 변수의 이름이 같을 경우 지역 우선 등(아 이제보니 지역할당제네 ㅋㅋ).

블록 내부에서 변수, 상수가 사용된 경우 컴파일러는 이 변수가 정의된 위치를 다음의 순서에 따라 검색한다.

> 1. 함수 내부에서 정의된 변수 
> 2. 함수 외부에서 정의된 변수
> 3. 글로벌 범위에서 정의된 변수
> 4. import 된 라이브러리 범위

## 일급 객체로서의 함수

이제 함수형 언어의 특징이 도드라진다. **일급 객체(First-Class Object)** 라는 용어는 크리스토퍼 스트래치(Christopher Strachey)라는 영ㄲ의 컴퓨터 과학자가 1960년대에 처음 사용한 개념으로서, 프로그램 언어 안에서 특정 종류의 객체가 일급의 지위를 가지는가에 대한 의미이다.

객체가 다음의 조건을 만족하는 경우 이 객체를 일급 객체로 간주한다.

> 1. 객체가 런타임에도 생성이 가능해야 한다.
> 2. 인자값으로 객체를 전달할 수 있어야 한다.
> 3. 반환값으로 객체를 사용할 수 있어야 한다.
> 4. 변수나 데이터 구조 안에 저장할 수 있어야 한다.
> 5. 할당에 사용된 이름과 관계없이 고유한 구별이 가능해야 한다.

함수가 이런 조건을 만족하면 이를 **일급 함수(First-Class Function)**라고 하고 그 언어를 함수형 언어로 분류한다. 함수형 언어에서는 함수가 일급 객체로 대우 받는다. 생각해보면 RN도 이런 특징이 있었으니 함수형 언어지. 그리고 찾아보니 함수형 언어의 정의는 여러 가지가 있는데, 지금과 같은 정의로 함수가 일급 객체 취급을 받는 걸로 정의한다면 javascript도 함수형 언어이다. 

이게 헷갈린다면 자바를 생각해보자. 자바에서는 클래스가 일급의 지위를 갖는다.

### 일급 함수의 특성 ① - 변수나 상수에 함수를 대입할 수 있음

문자 그대로 이해하면 된다. 다른 특징은, **함수 타입(Function Types)** 이라는 개념이다. 함수 타입은 일반적으로 함수 형태를 축약한 거라 필요한 것만 취한다. 이름이나 레이블은 다 치우고, 인자 타입과 반환 타입만 남긴다. 

```swift 
func boo(age: Int, name: String) -> String {
    return ("\(name)의 나이는 \(age)세 입니다.")
}

let fn: (Int, String) -> String = boo // 이렇게 이름만 써도 되고
let s: (Int, String) -> String = boo(age:name:) // 식별자를 다 써도 된다
let s2 = boo(age:name:) // 근데 식별자를 다 적어주면 함수를 특정할 수 있으니 타입 안적어줘도 된다.
```

주의할 점은 타입 어노테이션과 함수 이름의 조합으로 대입 구문을 구성하면 안될 때가 있다는 점이다. 동일한 함수 타입을 사용하지만 매개변수 명이 서로 다른 경우가 이 경우이다(당연히 함수 타입만으로는 구분이 안되니깐 이 조합으로 안되는 것이겠죠?). 그래서 이 경우에는 함수의 식별자를 사용해주어야 한다.

```swift
func boo(age: Int, name: String) -> String {
    return "\(name)의 나이는 \(age)세 입니다."
}

func boo(height: Int, nick: String) -> String {
    return "\(nick)의 키는 \(height)입니다."
}

//let fn03: (Int, String) -> String = boo // ambiguous 하다고 컴파일러가 오류를 뿜는다.
//let fn04: (Int, String) -> String = boo
let fn03 = boo(age:name:)
let fn04 = boo(height:nick:)
```

Void도 있는데 얘는 스위프트 내부에서 타입 알리어스로 정의되어있는 빈 튜플이다. 클래스나 구조체 등의 객체가 아닌 키워드임에 주의하자.

> public typealias Void = ()

원래 빈 반환값 뿐만 아니라 빈 인자에도 사용할 수 있었는데 스위프트4.0부터는 빈 반환 타입에만 사용할 수 있도록 제한되었다. 

### 일급 함수의 특성 ② - 함수의 반환 타입으로 함수를 사용할 수 있음

함수가 일급 객체로 대우받기 때문에(크..) 반환 타입에 함수를 쓸 수 있다.

```swift
func desc() -> String {
    return "this is desc()"
}

func pass() -> () -> String {
    return desc
}

let p = pass()
p() // "this is desc()"
```

이처럼 함수의 반환값이 함수인 경우 함수의 형식이 복잡해질 가능성이 크다(함수 타입 적는다고). 그래서 최근 문법에서는 인자값 부분에 괄호를 통해 감싸주도록 강제하지만 당연히 복잡한 형태의 함수 타입을 사용할수록 형식을 분석하기 어렵겠지? 하지만! 읽는 요령이있다! 거창한 건 아니고 젤 왼쪽 화살표부터 하나씩 읽는 것. 화살표 기준 왼쪽은 인자타입, 오른쪽은 반환타입이다. 그리고 화살표를 하나씩 해석해나가면 된다.

간단한 계산기를 만들어보며, 이 예시를 보자. 

```swift
func plus(a: Int, b: Int) -> Int {
    return a + b
}

func minus(a: Int, b: Int) -> Int {
    return a - b
}

func times(a: Int, b: Int) -> Int {
    return a * b
}

func divide(a: Int, b: Int) -> Int {
    guard b != 0 else {
        return 0
    }
    return a / b
}

func calc(_ operand: String) -> (Int, Int) -> Int {
    switch operand {
    case "+":
        return plus
    case "-":
        return minus
    case "*":
        return times
    case "/":
        return divide
    default:
        return plus
    }
}

let c1 = calc("+")
c1(3, 4) // 7

let c2 = calc("-")
c2(4, 3) // 1

let c3 = calc("*")
c3(3, 4) // 12

let c4 = calc("/")
c4(12, 3) // 4
```

약간 내가 눈여겨봐야할 점은, `calc("+")(3, 4)` 처럼 작성하는 게 난 더 좋을 줄 알았지만 이 경우 가독성이 매우 떨어진다고 한다. 그러니 특별히 줄여야할 이유가 없다면 가독성을 위해 가급적 다음과 같이 단계적으로 표현하자.

```swift
let c1 = calc("+")
c1(3, 4) // 7
```

### 일급 함수의 특성 ③ - 함수의 인자값으로 함수를 사용할 수 있음

javascript 생각하면 돼. 우리 콜백함수 넘겨주던 것처럼. 사족이지만 자바스크립트 사용한 게 여기서 도움되는구나 ㅋㅋ. 바로 예시 들어간다!

```swift
func incr(param: Int) -> Int {
    return param + 1
}

func broker(base: Int, function fn: (Int) -> Int) -> Int {
    return fn(base)
}

broker(base: 3, function: incr) // 4
```

지금 broker 함수는 정의된 타입에 맞는 함수가 입력되기만 하면 그게 어떤 함수이든 간에 그냥 실행하고 그 결과를 반환해 버린다. 그러니 borker(base:function:) 함수의 정의 구문만으로는 어떤 연산이 일어날지 짐작하기 어렵다. 실질적인 연산은 인자값으로 받는 함수에 달려 있기 때문이다. 보통 이런 식으로 중개 역할을 하는 함수를 **브로커(Broker)** 라고 한다.

이처럼 함수를 인자로 사용하면 실행 전까지 어떤 구문이 수행될지 컴파일러가 미리 알 수 없으므로 컴파일 시점에서 디버깅할 수 없다는 단점이 있다. 하지만 잘만 사용하면 동적으로 정의되는 훌륭한 함수를 만들 수 있기 때문에 매애직 코드를 작성할 수 있다.

그럼 이번엔 콜백 예시를 보자! 이얏호!

```swift
func successThrough() {
    print("연산 처리가 성공했습니다.")
}

func failThrough() {
    print("처리 과정에 오류가 발생하였습니다.")
}

func divide(base: Int, success sCallBack: () -> Void, fail fCallBack: () -> Void) -> Int {
    guard base != 0 else {
        fCallBack()
        return 0
    }
    
    defer {
        sCallBack()
    }
    return 100 / base
}

divide(base: 30, success: successThrough, fail: failThrough)
```

예스 코드에서 눈여겨볼 부분은 새롭게 등장한 `defer` 이다. defer 블록은 함수나 메소드에서 코드의 흐름과 상관없이 가장 마지막에 실행되는 블록이다. 이 블록에 작성된 구문은 작성된 위치에 상관없이 항상 함수의 종료 직전에 실행되기 때문에, 종료 시점에 맞추어 처리해야 할 구문이 있다면 어디서 적을지 고민하지 말고 defer 블록에 넣어두기만 하자. 실제로 이 블록은 함수에서 사용된 각종 리소스 처리나 해제, 연결 종료 등의 구문을 처리하는 용도로 유용하게 사용된다. defer 블록은 다음과 같은 특성을 가지고 있다.

> 1. defer 블록은 작성된 위치와 순서에 상관없이 함수가 종료되기 직전에 실행된다.
> 2. defer 블록을 읽기 전에 함수의 실행이 종료될 경우 defer 블록은 실행되지 않는다.
> 3. 하나의 함수나 메소드 내에서 defer 블록을 여러 번 사용할 수 있다. 이때에는 가장 마지막에 작성된 defer 블록부터 역순으로 실행된다.
> 4. defer 블록을 중첩해서 사용할 수 있다. 이때에는 바깥쪽 defer 블록부터 실행되며 가장 안쪽에 있는 defer 블록은 가장 마지막에 실행된다.

defer는 주로 함수가 연산을 처리하는 과정에 영향을 끼치지 않으면서 실행해야 할 다른 내용이 있을 때 사용하거나, 함수를 종료하기 직전에 정리해야 하는 변수나 상수값들을 처리하는 용도로 사용된다. 즉, 함수를 종료하기 전에 처리해야 하는 변수나 상수들 중에서 처리 시점이 모두 달라서 적절한 처리 시점을 잡기 어려울 때 defer 구문을 통해 처리하면 된다는 뜻이다.

음 추가로 이렇게 함수를 인자로 전달할 경우 함수 내부의 흐름에 우리가 끼어들 수 있는 여지가 생기는 것이다. 함수 외부에서 함수 내부에 실행 구문을 추가할 수 있다는 것은, 함수를 그만큼 재활용할 수 있다는 장점이 되기도 한다. 함수를 공통으로 사용할 수 있는 범위가 늘어나는 것!

근데... 함수에 넘겨줄 인자용 함수를 매번 새로 작성하는 건 번거롭잖아? 그래서 다른 언어들과 마찬가지로 스위프트는 익명함수를 지원하는데 이를 (특이하게도) **클로저(Closure)**라고 부른다. 자세한 건 나중에.

## 함수의 중첩 + 클로저(Closure)

자바스크립트의 클로저 개념과 거의 같다. 예시를 들면 다음과 같다.

```swift
func outer(param: Int) -> (Int) -> String {
    
    func inner(inc: Int) -> String {
        return "\(inc)를 리턴합니다"
    }
    
    return inner
}

let fn1 = outer(param: 3)
let fn2 = fn1(30) 
```

outer 함수는 inner 함수를 리턴하는데, outer가 호출되고 소멸함에도 불구하고 내부 함수인 inner 함수는 fn1에 할당 된 채로 살아있다. 

```swift
func basic(param: Int) -> (Int) -> Int {
    let value = param + 20
    
    func append(add: Int) -> Int {
        return value + add
    }
    
    return append
}

let result = basic(param: 10)
result(10) // 40
```

외부 함수인 basic이 호출되고 생명주기가 끝났지만 내부 함수 append는 반환되어 result에 할당되고 또 외부 함수의 지역 변수인 value 역시 append에서 참조하고 있기 때문에 살아남는다. 이 원인은 바로 클로저 때문이다. append 함수가 클로저를 갖기 때문이다. 클로저를 설명하면 다음과 같다. (클로저는 내부함수 + 주변 환경(context))

> 1. 클로저는 두 가지로 이루어진 객체이다. 하나는 내부 함수이며, 또 다른 하나는 내부 함수가 만들어진 주변 환경이다.
> 2. 클로저는 외부 함수 내에서 내부 함수를 반환하고, 내부 함수가 외부 함수의 지역 변수나 상수를 참조할 때 만들어집니다.

**"클로저란 내부 함수와 내부 함수에 영향을 미치는 주변 환경(Context)을 모두 포함한 객체이다"**

다만 스위프트에서 클로저는 추가로 익명함수를 적는 표현식도 클로저라고 부른다. 그래서 스위프트에서 클로저라고 부르는 객체는 대부분 다음 세 가지 경우 중 하나이다

> 1. 전역 함수: 이름이 있으며, 주변 환경에서 캡처할 어떤 값도 없는 클로저
> 2. 중첩 함수: 이름이 있으며 자신을 둘러싼 함수로부터 값을 캡처할 수 있는 클로저
> 3. 클로저 표현식: 이름이 없으며 주변 환경으로부터 값을 캡처할 수 있는 경량 문법으로 작성된 클로저

1, 2번은 앞서 살펴본 내부 함수 살아남고, 주변 환경이 살아남는 내용이고 이번엔 익명함수 표현식인 클로저 표현식에 대해서 더 자세히 알아보자.

### 클로저 표현식

간단하게 func 키워드 생략, 함수의 이름 생략하고 나머지 부분만 작성하는 경량문법을 사용한다.

```swift
{ () -> () in
    print("클로저가 실행됩니다.")
}
```

클로저 표현식은 중괄호로 시작하고 중괄호로 끝나니 함수의 body를 대신해서 in 키워드를 사용해서 표현한다. 또한 함수 타입을 표현하는 것처럼 반환값이 없을 때는 빈 괄호 혹은 Void를 이용해서 표현해줘야 한다. 왜냐하면 반환값이 있는데 컴파일러가 추론할 수 있도록 생략한 것과, 실제로 반환값이 없는 경우를 구분하기 위해서이다.

클로저 즉시 실행 역시 자바스크립트와 유사하게 괄호 () 로 감싸고 실행시키는 것.

```swift
(({ () -> () in
    print("클로저가 실행됩니다.")
})()
)()
```

단, 프로그래밍 언어는 문법을 간결하게 작성하면 할수록 가독성이 떨어지는데 클로저는 이러한 특성이 매우 두드러지므로 작성 시 간결성과 가독성의 비율을 항상 고려하자.

### 클로저 표현식 경량화

sort(by:) 메소드를 통해서 클로저 표현식을 경량화해나가보자. 다음과 같은 배열 하나가 있다고 가정하자. 우리는 sort(by:)를 통해 내림차순으로 정렬하고자 한다.

```swift
var value = [1, 9, 5, 7, 3, 2]
```

sort(by:)의 정렬 기준 함수는 순서대로 인자값을 받아 두 개의 인자를 받고, 첫 번째 인자값이 두 번째 인자값보다 앞쪽에 와야 한다고 판단되면 true를, 이외에는 false를 반환함으로써 비교 결과를 전달한다. 

먼저 클로저 없이 함수를 정의해서 해보자

```swift
var value = [1, 9, 5, 7, 3, 2]

func order(s1: Int, s2: Int) -> Bool {
    if s1 > s2 {
        return true
    } else {
        return false
    }
}

value.sort(by: order)
```

다음은 이 함수를 클로저 표현식으로 바꾸어 작성해보자

```swift
var value = [1, 9, 5, 7, 3, 2]

value.sort(by: {(s1: Int, s2: Int) -> Bool in
            if s1 > s2 {
                return true
            } else {
                return false
            }
})
```

이 코드에서 클로저 표현식은 여러 줄에 작성되었지만 다음과 같이 간결화할 수 있다.

```swift
{ (s1: Int, s2: Int) -> Bool in return s1 > s2}
```

이번에는 스위프트에서 제공하는 문법을 활용하여 클로저 표현식을 간결하게 해보자. 클로저 표현식은 반환값의 타입을 생략할 수 있다. 그러면 컴파일러가 클로저 표현식을 해석하여 반환값을 찾고 추론해서 반환 타입을 정의한다.

```swift
{(s1: Int, s2: Int) in 
	return s1 > s2
}
```

근데 여기서 더 줄일 수 있다. 이번엔 매개변수의 타입 정의 부분이다. 여기도 생략하면 역시 컴파일러가 실제로 대입되는 값을 기반으로 추론해낸다.

```swift
{ s1, s2 in return s1 > s2}
```

근데 와우 이번엔 매개변수도 생략할 수 있다. 매개변수가 생략되면 매개변수명 대신 $0, $1, $2.. 와 같은 이름으로 할당된 내부 상수를 이용할 수 있다. 얘네는 입력받은 인자값의 순서대로 매칭된다(쉘스크립트와 유사). 그래서 s1 대신 $0, s2 대신 $1이 사용된다. 

이제 매개 변수가 생략되면 남는 것은 실행 구문이다. 매개변수와 실행부분을 구분할 필요가 없으니 in 키워드도 날려도 된다.

```swift
{ return $0 > $1}
```

그래서 이번에 줄이면 다음과 같이 된다.

```swift
value.sort(by: { return $0 > $1})
```

생략된 부분이 많지만 구문 자체는 명확하다.

근데 사실, sort 메소드에는 클로저 표현식보다 더 간결하게 표현할 수 있는 방법이 있다. 바로 연산자 함수(Operator Functions)라고 부르는 것인데 연산자만을 사용하여 의미하는 바를 정확히 나타낼 수 있을 때 사용된다. 그래서 이것까지 사용하면 최종적으로 sort 메소드는 다음과 같다.

```swift
value.sort(by: >)
```

간결함의... 끝판왕... 부등 비교 연산자는 원래 두 개의 인자가 필요하고, 이를 첫 번째 인자와 두 번째 인자로 해석하면 비교 연산자 하나만으로 함수처럼 표현할 수 있기 때문에 이같은 표현이 가능하다.

## 트레일링 클로저(Trailing Closure)

함수의 마지막 인자값이 클로저일 때, 이를 인자값 형식으로 작성하는 대신 함수의 뒤에 꼬리처럼 붙일 수 있는 문법을 의미한다. 이렇게 작성함으로써 코드 가독성이 좋아지고 작성도 쉬워진다! 인자가 클로저 하나만 있으면 인자 괄호도 생략가능하다(sort 같이)

대신 주의할 점은 이 문법은 함수의 마지막 인자값에만 적용된다. 클로저 2개가 마지막 인자로 주어져도 연속해서 트레일링 클로저를 쓸 수 있는 게 아니라 오직 마지막 클로저만 트레일링 클로저를 쓸 수 있다.

```swift
// 인자 하나가 클로저일 경우 인자 괄호 생략 가능!
var value = [1, 9, 5, 7, 3, 2]
value.sort() { (s1, s2) in return s1 > s2}
value.sort {
  (s1, s2) in return s1 > s2
}
```

```swift
// 마지막 클로저만 트레일링!
func divide(base: Int, success s: () -> Void) -> Int {
    defer {
        s()
    }
    return 100 / base
}
divide(base: 100){
    print("연산이 성공했습니다.")
}
```

```swift
// 클로저가 마지막에 연속해서 인자로 등장해도, 맨 마지막만 트레일링!
func divide(base: Int, success s: () -> Void, fail f: () -> Void) -> Int {
    guard base != 0 else {
        f()
        return 0
    }
    defer {
        s()
    }
    return 100 / base
}

divide(base: 100, success: {
    () in print("연산이 성공했습니다.")
}){
    () in print("연산이 실패 했습니다.")
}
```

### @escaping 과 @autoclosure

클로저를 함수나 메소드의 인자값으로 사용할 때에는 용도에 따라 @escaping 과 @autoclosure 속성을 부여할 수 있다.

#### > @escaping

클로저는 인자로 전달되면 기본적으로 **탈출불가(non-escape)** 의 성격을 가진다. 이는 해당 클로저를 **1. 함수 내에서 2. 직접 실행을 위해서만 사용** 해야한다는 것을 의미한다. 그래서 클로저를 다음처럼 변수나 상수에 할당할 경우 오류가 발생한다.

```swift
func callback(fn: () -> Void) {
    let f = fn
    f()
}

callback {
    print("Closure가 실행되었습니다.")
}
```

클로저가 함수 내부에서 변수나 상수에 대입하는 걸 허용하면 내부 함수를 통핸 캡처기능을 이용하여 클로저가 바깥으로 탈출할 수 있기 때문이다(함수 내부 범위를 벗어나서 실행될 가능성이 있음). 

같은 의미로, 인자값으로 전달된 클로저는 중첩된 내부 함수에서 사용할 수도 없다. 허용할 경우 역시 Context Capture를 통해 탈출될 수 있기 때문.

근데 코드를 작성하다보면 클로저를 변수나 상수에 대입하거나 중첩함수 내부에서 사용해야할 경우도 있는데 이때 사용되는 것이 @escaping 속성이다.

```swift
func callback(fn: @escaping () -> Void) {
    let f = fn
    f()
}

callback {
    print("Closure가 실행되었습니다.")
}
```

이제 클로저는 변수나 상수에 할당도 가능하고 중첩된 내부 함수에 사용할 수 있고, 함수 바깥으로 전달할 수도 있다. 말 그대로 탈출 가능한 클로저가 된 것.

그렇다면 인자값으로 전달되는 클로저의 기본 속성이 탈출불가하도록 설정된 이유는 무엇일까?

클로저의 기본 속성을 탈출불가하게 관리함으로써 얻어지는 가장 큰 이점은 컴파일러가 코드를 최적화하는 과정에서의 성능향상이다. 클로저가 탈출할 수 없다는 것은 컴파일러가 더 이상 메모리 관리상의 지저분한 일들에 관여할 필요없다는 뜻이기 때문이다.

추가로 탈출불가 클로저 내에서는 self 키워드를 사용할 수 있다. 왜냐하면 이 클로저는 해당 함수가 끝나서 리턴되기 전에 호출될 것이 명확하기 때문이다. 따라서 클로저 내에서 self에 대한 약한 참조(weak reference)를 사용해야할 필요가 없다.

#### > @autoclosure

@autoclosure 속성은 인자값으로 전달된 일반 구문이나 함수 등을 클로저로 Wrapping 하는 역할을 한다. 이 속성을 적용하면 인자값을 '{ }' 형태가 아니라 '( )'형태로 사용할 수 있다는 장점이 있다.

```swift
func condition(stmt: @autoclosure () -> Bool) {
    if stmt() == true {
        print("결과가 참입니다.")
    } else {
        print("결과가 거짓입니다.")
    }
}

condition(stmt: (4 > 2))
// 클로저니깐 더이상 사용 불가
//condition {
//    4 > 2
//}
```

@autoclosure 속성을 사용함으로써 트레일링 클로저 구문을 사용할 수 없고 반드시 위의 형태로 호출해야한다.

핵심은 클로저가 아니라 그 안에 들어가는 내용만 인자값으로 넣어주는 것이다. { } 대신 ( ) 를 사용함으로써 훨씬 더 자연스럽고 익숙한 구문으로 사용할 수 있다.

@autoclosure 속성과 관련하여 추가로 알아두어야 할 개념이 하나 있다. 바로 '지연된 실행' 이다. 

```swift
// 빈 배열 정의
var arrs = [String]()

func addVars(fn: @autoclosure () -> Void) {
    // 배열 요소를 3개까지 추가하여 초기화
    arrs = Array(repeating: "", count: 3)
    // 인자값으로 전달된 클로저 실행
    fn()
}

// 구문1: 오류 발생
arrs.insert("KR", at: 1)
```

이 코드는 당연히 오류가 발생한다. arrs 배열이 아직 확장되지 않았기에 인덱스 범위를 벗어났다는 오류를 뿜는다. 이제는 동일한 구문이지만 이를 함수 addVars(fn:)의 인자값으로 넣어보자.

```swift
// 빈 배열 정의
var arrs = [String]()

func addVars(fn: @autoclosure () -> Void) {
    // 배열 요소를 3개까지 추가하여 초기화
    arrs = Array(repeating: "", count: 3)
    // 인자값으로 전달된 클로저 실행
    fn()
}

// 구문2: 오류가 발생하지 않는다.
addVars(fn: arrs.insert("KR", at: 1))
```

신기하게도 오류가 발생하지 않는다. 이것이 바로 **지연된 실행**이다. 원래 구문은 작성하는 순간에 실행되는 것이 맞지만, 함수 내에 작성된 구문은 함수가 실행되기 전까지는 실행되지 않는다. @autoclosure 속성이 부여된 인자값은 보기엔 일반 구문 형태이지만 컴파일러에 의해 클로저, 즉 함수로 감싸지기 때문에 위와 같이 작성해도 addVars(fn:) 함수 실행 전까지는 실행되지 않고 해당 구문이 실행될 때에는 이미 배열의 인덱스가 확장된 후이므로 오류도 발생하지 않는 것이다.

정리하자면 @autoclosure 속성이 인자값에 부여되면 해당 인작밧은 컴파일러에 의해 클로저로 자동 래핑된다. 이 때문에 함수를 실행할 때에는 '{ }' 형식의 클로저가 아니라 '( )' 형식의 일반값을 인자값으로 사용해야 한다. 또한 인자값은 코드에 작성된 시점이 아니라 해당 클로저가 실행되는 시점에 맞추어 실행된다. 이를 지연된 실행이라 부르며, @autoclosure 속성이 가지는 주요한 특징 중의 하나라고 할 수 있다.





