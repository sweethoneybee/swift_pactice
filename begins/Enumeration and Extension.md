# 열거형

 열거형이란 하나의 주제로 연관된 데이터들이 멤버로 구성되어 있는 자료형 객체를 말한다. 다른 언어에서 보이는 enum 타입과 유사하다. 집단 자료형(배열이나 집합, 딕셔너리 등) 대신에 열거형을 쓰는 이유는, 열거형을 정의하는 시점에 열거형의 데이터들도 정의되기에 아이템을 삭제, 수정할 수 없으며 변경하거나 삭제하려면 객체를 정의하는 구문을 직접 수정해야 한다. 열거형 데이터는 정의되는 개념으로 타입으로 사용할 수 있으며 컴파일러가 미리 인지할 수 있다.

그래서 열거형을 쓰면 런타입 오류 대신에 컴파일 오류로 컴파일러가 잡아줄 수 있다. 그래서 리터럴로 직접 값을 입력받는 것보다는 열거형 타입으로 각 값에 해당하는 멤버를 정의하고 사용하는 것을 저자가 추천하는 코딩습관이라고 한다.

일반적으로 다음의 조건들을 만족하는 경우에 값을 직접 입력하거나 집단 데이터 타입을 사용하는 것보다 열거형 객체를 정의해서 사용하는 것이 훨씬 좋다고 조언한다.

> 1. 원치 않는 값이 잘못 입력되는 것을 막고 싶을 때
> 2. 입력받는 값을 미리 특정할 수 있을 때
> 3. 제한된 값 중에서만 선택할 수 있도록 강제하고 싶을 때

예시는 다음과 같다

> * 성별: 남, 여, 히즈라(hijra, 제3의 성)
> * 국가: 한국, 일본, 미국, 중국, 인도, 호주, 캐나다, 영국, 프랏으
> * 지역: 서울, 부산, 강원, 충남, 충북, 경남, 경북, 전남, 전북, 제주
> * 직급: 사원, 대리, 과장, 차장, 부장, 이사, 사장
> * 색상: 빨강, 노랑, 초록
> * 방향: 동, 서, 남, 북

예시들의 공통점은 무한히 늘어나지 않고 미리 특정할 수 있는 값들이며 각 줄마다 공통된 주제로 연관되는 값들로 구성되어 있다는 점이다.

## 문법

정의 구문은 다음과 같다

```swift
enum 열거형 이름 {
	// 열거형의 멤버 정의
	case 멤버값 1
	case 멤버값 2
	case ...
}
```

열거형의 이름은 대문자로 시작하는 CamelCasing, 멤버값은 소문자로 시작하는 camelCasing으로 한다. case 한 줄에 여러개의 멤버를 쉼표로 구분하여 적어도 동일하지만 가독성을 고려해서 적자. 사용법은, 열거형 이름에 점(.) 연산자를 붙여서 호출한다.

```swift
enum Direction {
  case north
  case south
  case east, west
}

let N = Direction.north
let S = Direction.south
let E = Direction.east
let W = Direction.west
```

### 열거형 객체 사용

열거형 이름에 점(.) 연산자를 붙이면 호출할 수 있는데, 타입을 컴파일러가 알고 있다면 열거형이름을 생략하고 점(.)연산자 만으로도 사용할 수 있다.

```swift
var directionToHead: Direction = Direction.west
direction = .east

// 이건 안됨
var directionToHead2 = .east

// 이건 됨
var directionToHead3: Direction = .east
```

## switch 문과 열거형 연계

두 가지만 기억하자. switch문에 열거형을 사용하면 switch 옆의 비교 대상이 있으니 case 블록의 열거형 이름을 생략할 수 있고, 열거형에서 정의된 멤버를  switch 구문의 case 블록 비교에 전부 사용하면 default 구문을 생략할 수 있다는 점이다. 

앞서서 switch를 학습할 때 배운 건데, switch case 블록에서 모두 매칭이 되게 해야하기 때문에 default는 사실상 필수였다. 생략이 가능한 경우는 바로 지금과 같은 경우. 열거형에서 정의된 모든 멤버를 사용하면 더 비교할 게 없으니 default를 생략할 수 있는 것. 멤버가 일부 누락되고 default를 적지 않으면 오류가 난다. 

이와는 반대로 switch 구문에서 default 블록을 추가하면, 모든 멤버를 다 비교할 필요가 없으므로 꼭 비교해야할 일부 멤버만 비교하고 나머지는 default 구문에 맡기면 된다.

예시코드는 아래와 같다. 첫 번째는 정석, 두 번째는 생략 가능한 부분(열거형 이름을 컴파일러가 알기 때문에 생략 가능)을 생략한 것.

```swift
enum Direction {
  case north
  case south
  case east, west
}

var directionToHead: Direction = Direction.west

// 정석
switch directionToHead {
case Direction.north:
    print("북쪽입니다.")
case Direction.south:
    print("남쪽입니다.")
case Direction.east:
    print("동쪽입니다.")
case Direction.west:
    print("서쪽입니다.")
}

// 타입추론으로 열거형 이름 생략
switch directionToHead {
case .north:
    print("북쪽입니다.")
case .south:
    print("남쪽입니다.")
case .east:
    print("동쪽입니다.")
case .west:
    print("서쪽입니다.")
}
```

## 멤버와 값의 분리

열거형의 멤버에는 값을 부여할 수도 있다. C언어나 오브젝티브-C에서도 지원하는 기능이지만 이들은 정수값만 정의할 수 있고 임의의 값의 지정할 수 없는 반면에, 스위프트에서는 훨씬 넓게 지원한다.

멤버에 값을 할당할 때는 열거형 이름 뒤에 타입 어노테이션을 표기해줘야한다. 또 해당 멤버의 값을 접근할 때는 .rawValue 속성을 이용한다.

```swift
enum HTTPCode: Int {
    case OK = 200
    case NOT_MODIFY = 304
    case INCORRECT_PAGE = 404
    case SERVER_ERROR = 500
}


HTTPCode.OK.rawValue // 200
var temp = HTTPCode.NOT_MODIFY
temp.rawValue // 304
```

문자열, 정수, 실수, 기타 다른 자료형까지 모두 멤버에 할당 가능하며 자동할당 기능도 지원한다. 타입어노테이션과 시작할 정수값을 지정하면 된다. 일부 멤버만 값을 주고 나머지는 생략하면 생략 직전의 값부터 1씩 증가하는 값이 자동으로 할당된다. 예시코드는 아래와 같다.

```swift
enum Rank: Int {
    case one = 1
    case two, three, four, five
}

Rank.one.rawValue // 1
Rank.two.rawValue // 2
Rank.three.rawValue // 3
Rank.four.rawValue // 4
Rank.five.rawValue // 5
```

```swift
enum Rank: Int {
    case one = 10
    case two = 20
    case three, four, five
}

Rank.one.rawValue // 10
Rank.two.rawValue // 20
Rank.three.rawValue // 21
Rank.four.rawValue // 22
Rank.five.rawValue // 23
```

### 연관 값(Associated Values)

열거형 객체의 멤버와 값은 선언하는 시점에서 정의되지만, 사용하는 시점에서 멤버에 보조값을 설정할 수 있는 방법도 있다. 이렇게 설정된 값을 연관 값(Associated Values)라고 한다.

```swift
enum ImageFormat {
    case JPEG
    case PNG(Bool)
    case GIF(Int, Bool)
}

var newImage = ImageFormat.PNG(true)
newImage = ImageFormat.GIF(256, false)
```

연관 값을 이용하면 멤버를 적게 유지하면서 멤버를 세부적으로 구분할 수 있다. 이외에도 실행 시점에서 값을 저장해야할 필요가 있을 때 요긴하게 사용된다.

## 열거형 프로퍼티, 메소드

열거형에서는 클래스, 구조체럼 연산 프로퍼티와 메소드를 정의할 수 있다. 인스턴스를 만들 수는 없지만 열거형의 멤버를 인스턴스처럼 사용할 수 있으므로 인스턴스 프로퍼티/메소드와 타입 프로퍼티/메소드를 모두 정의할 수 있다.(단, 인스턴스 저장 프로퍼티는 사용불가. 타입 저장 프로퍼티는 사용 가능)

```swift
enum HTTPCode: Int {
    case OK = 200
    case NOT_MODIFY = 304
    case INCORRECT_PAGE = 404
    case SERVER_ERROR = 500
    
    var value: String {
        return "HTTPCode number is \(self.rawValue)"
    }
    
    func getDescription() -> String {
        switch self {
        case .OK:
            return "응답이 성공했습니다. HTTP 코드는 \(self.rawValue)입니다."
        case .NOT_MODIFY:
            return "변경된 내역이 없습니다. HTTP 코드는 \(self.rawValue)입니다."
        case .INCORRECT_PAGE:
            return "존재하지 않는 페이지입니다. HTTP 코드는 \(self.rawValue)입니다."
        case .SERVER_ERROR:
            return "서버 오류입니다. HTTP 코드는 \(self.rawValue)입니다."
        }
    }
    
    static func getName() -> String {
        return "This Enumeration is HTTPCode"
    }
}

var response = HTTPCode.OK
response = .NOT_MODIFY

response.value
response.getDescription()

HTTPCode.getName()
```

value와 getDescription()은 인스턴스 메소드 성격이기 때문에 멤버를 할당받은 변수 response에서 호출하지만, getName()은 타입 메소드이므로 열거형 타입 자체에서 호출한다. 이와 같은 방식을 사용하여 열거형에 프로퍼티나 메소드를 정의해두면, 필요할 때 요긴하게 사용할 수 있어 효율적이라고 한다.

열거형의 장점을 충분이 이해하고, 코드 작성 시 사용자의 직접 입력을 열거형 선택으로 대체할 수 있다면 적극적으로 활용하도록 하자.

# 익스텐션(Extension)

익스텐션은 이미 존재하는 클래스나 구조체, 열거형 등의 객체에 새로운 기능을 추가하여 확장해주는 구문이다. 새로운 객체를 정의하는 것이 아닌 이미 존재하는 객체에 여러 가지 요소를 추가해준다.

오브젝티브-C에서 제공되는 카테고리(Category)와 비슷하다. 차이점은 카테고리는 자체적인 이름을 가지고 클래스만 적용할 수 있는 반면, 스위프트의 익스텐션은 자체적인 이름을 가지지 않고 클래스뿐만 아니라 구조체나 열거형 등의 객체에 대해서 기능을 추가할 수 있다.

익스텐션으로 구현할 수 있는 것들을 다음과 같다.

> * 새로운 연산 프로퍼티를 추가할 수 있다.
> * 새로운 메소드를 정의할 수 있다.
> * 새로운 초기화 구문을 추가할 수 있다.
> * 네 기존 객체를 수정하지 않고 프로토콜을 구현할 수 있다.

extension의 문법은 다음과 같다.

```swift
extension <확장할 기존 객체명> {
  // 추가할 기능에 대한 구현 코드를 작성
}
```

## 익스텐션과 연산 프로퍼티

익스텐션을 사용하면 프로퍼티를 추가할 수 있지만, 열거형과 마찬가지로 연산 프로퍼티만을 추가할 수 있다. 대신 인스턴스 프로퍼티든 타입 프로퍼티든 연산 프로퍼티라면 모두 추가할 수 있다.

```swift
extension Double {
    var km: Double { return self * 1_000.0}
    var m: Double { return self }
    var cm: Double { return self / 100.0}
    var mm: Double { return self / 1_000.0 }
    var description: String {
        return "\(self)km는 \(self.km)m, \(self)cm는 \(self.cm)m, \(self)mm는 \(self.mm)m입니다."
    }
}

2.km // 2000m
5.5.cm // 0.055m
125.mm // 0.125m
print(7.0.description) // "7.0km는 7000.0m, 7.0cm는 0.07m, 7.0mm 0.007m입니다"
```

참고로 연산 프로퍼티를 정의하는 과정에서 숫자에 1_000처럼 언더바가 추가된 부분이 있는데 이는 단순히 자릿수를 구분해지기 위해 넣은 것으로 언더바를 사용하지 않고 표기한 것과 아무런 차이가 없다.

## 익스텐션과 메소드

오버로딩 특성을 이용해서 새로운 메소드를 정의할 수 있고, 매개변수명을 변경하여 새로운 메소드를 작성할 수도 있다. 하지만 **기존 객체에서 사용된 같은 메소드를 익스텐션에서 재정의하는 것은 안된다.** 즉 오버라이딩은 안된다는 의미이다. 오버라이딩은 상속에서만 가능하다.

```swift
extension Int {
    func repeatRun(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

let d = 3
d.repeatRun(task: {
    print("반갑습니다!")
})

// 트레일링 클로저
d.repeatRun {
    print("반갑습니다.")
}
```

인스턴스 메소드는 익스텐션에서도 mutating 키워드를 사용하여 인스턴스 자신을 수정하도록 허용할 수 있다. 구조체나 열거형에서 mutating 키워드를 추가하고 프로퍼티나 인스턴스를 수정하듯이 익스텐션에서도 동일하게 한다.

```swift
extension Int {
    mutating func square() {
        self = self * self
    }
}

var value = 3
value.square()
```

당연한 거지만 상수에 할당한 경우 안되겠지? 구조체는 원래 상수에다 할당하면 변경이 불가능하니깐. 또한 값을 변수에 할당하지 않고 리터럴에 대해 직접 메소드를 호출해도 똑같다. 원본 값을 변경하는 건데 리터럴 값을 변경할 수는 없으니깐.

> 3.square() // X

익스텐션을 이용하여 이미 작성한 코드를 라이브러리화한 상태에서 추가할 게 생기면 매우 간단히 처리할 수 있다. 하지만 익스텐션을 남용하면 객체의 정의가 모호해지고 실행 위치에 따라 정의가 다 달라질 수 있다. 또한 객체의 정의가 파편화되기 쉬워서 객체의 정확한 구성을 파악하기 힘들어진다.

이를 방지하기 위해서 익스텐션은 필요한 곳에 충분히 사용하되 남용하지 않고, 전체적인 정의와 구조를 파악할 수 있는 위치에서 작성하는 것이 좋다.

## 익스텐션을 활용한 코드 정리

여러 스위프트의 코드들을 보면, 커스텀 클래스를 작성할 때 기본 코드만 정의하고 이어서 다시 익스텐션을 사용하여 나머지 코드를 보완하는 경우가 적지 않다고 한다. 예시는 다음과 같다.

```swift
import UIKit

public class DataSync {
    public func save(_ value: Any, forKey: String) {...}
    public func load(_ key: String) -> Any { ... }
    public func remove(_ key: String) {...}
}

extension DataSync {
    public func stringToDate(_ value: String) -> Date {...}
    public func dateToString(_ value: Data) -> String {...}
}
```

굳이 이렇게 적는 이유가 뭘까? 이런 방식은 익스텐션의 또다른 용법인데, 오브젝티브-C의 #pragma mark라는 주석과 용도가 닿아있다.

익스텐션을 이용해서 메소드를 분리하면 메소드가 많아도 유지 보수를 편하게 나눌 수 있다. Xcode의 점프 바에서 정의된 메소드들이 분리가 되며 저자는 이런 방식도 추천한다. 오버라이드 메소드는 기본 클래스 정의에 두고, 커스텀으로 추가한 메소드를 익스텐션 블록으로 옮겨서 정의한다. 무조건 이렇게 해야하는 것은 아니지만 자신만의 기준으로 나누어 코드를 작성할 때 좋은 예시가 될 수 있겠다. 참고로 익스텐션에서는 오버라이드 메소드를 작성할 수 없으니 이것만 참고해서 코드를 분리하자.

추가로 액션 메소드라고, @IBAction 어트리뷰트가 붙는 액션 메소드는 익스텐션에 작성할 수 없고 반드시 원래의 클래스에 작성해야 한다고 한다.

### 델리게이트 패턴

iOS 인터페이스를 구현할 때 델리게이트 패턴을 많이 사용하는데, 클래스 소스 코드가 자칫 더러워질 수 있으나 프로토콜 성격에 맞게 여러 개의 익스텐션으로 나누어 구현하면 깔끔한 코드를 얻을 수 있다.

### MARK 주석

주석에 MARK: 를 넣어서 Xcode 내 점프바에서 주석 내용을 확인할 수 있다.

추가로 MARK: - 까지 적으면 점프바에서 수평선 하나도 그어서 가독성을 더욱더 높여준다.

```swift
// MARK: 꼭 대문자 그리고 콜론(:)을 붙여서 써주자
// MARK: - 하이픈까지 넣으면 Xcode 점프바에서 수평선도 그어준다
```

