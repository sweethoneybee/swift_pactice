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

(재밌는 부분은 아껴먹자. 오늘은 여기까지)