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