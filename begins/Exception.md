# 예외처리

스위프트에서는 원래 옵셔널로만 에러를 핸들링하려 하였으나 옵셔널로만 할 경우 어떤 에러든 간에 결국 반환값이 nil이어서 에러를 특정짓기가 어렵다는 문제가 있었다. 그래서 결국 스위프트2에 다른 객체지향에서 보이는 예외를 던지는 방식의 문법이 도입되었다.

오류를 정의하는 내용은 다양하지만, 오류들의 다양한 경우를 표현하기에 가장 적합한 객체 타입이 바로 열거형이다. 

열거형을 오류 타입으로 사용하기 위해서는 반드시 Error 프로토콜을 구현해야한다. 그렇지 않으면 컴파일러가 오류를 뿜는다(아무 열거형이나 오류 타입에 쓰면 안되니깐). 이 Error 프로토콜은 실제로는 텅텅 비어있는 프로토콜이다. 정의 부분이 텅텅 비어있는데, 이처럼 **프로토콜을 구현했다는 사실 자체가 중요한 경우**가 많다. 일종의 인증마크같은 개념이다(이 객체는 Error 객체입니다처럼)

아래 예시코드는, 문자열을 분석하여 날짜 형식으로 처리하는 과정에서 발생할 수 있는 오류를 책에서 예시 코드로 정의한 부분이다.

```swift
enum DateParseError: Error {
    case overSizeString
    case underSizeString
    case incorrectFormat(part: String)
    case incorrectData(part: String)
}
```

## 오류 던지기

우리가 정의한 메소드나 함수에서 오류를 던질 수 있는데, 이 때 오류를 던질 수 있는 함수라고 표시를 하기 위해 throws 키워드를 추가한다. 이 키워드는 반환 타입을 표시하는 화살표 ('->') 보다 앞에 작성해야 한다. 함수나 메소드, 익명 함수인 클로저까지 모두 throws 키워드를 사용할 수 있지만 명시적으로 throws 키워드를 추가하지 않으면 오류를 던질 수 없다.

```swift
func canThrowErrors() throws -> String
func cannotThrowErrors() -> String
```

다만 실제로 오류를 던질 때는 throw 라는 키워드를 사용하니 주의하자(단수임).

그러면 이제 실제로 날짜를 분석하는 함수를 작성하고 실행 과정에서 발생할 수 있는 오류 상황에서 오류 객체를 던지는 예시코드를 살펴보자. 

NSString 타입의 문자열은 파운데이션 프레임워크에서 제공하는 것으로서 String 타입보다 사용할 수 있는 메소드가 다양하다. String 타입과 NSString 타입은 서로 호환이 된다. NSRange 객체도 파운데이션 프레임워크에 정의되어 있는 객체이다.

```swift
enum DateParseError: Error {
    case overSizeString
    case underSizeString
    case incorrectFormat(part: String)
    case incorrectData(part: String)
}

import Foundation

struct Date {
    var year: Int
    var month: Int
    var date: Int
}

func parseDate(param: NSString) throws -> Date {
    // 입력된 문자열의 길이가 10이 아닌 경우 분석이 불가능하므로 오류
    guard param.length == 10 else {
        if param.length > 10 {
            throw DateParseError.overSizeString
        } else {
            throw DateParseError.underSizeString
        }
    }
    
    // 반환할 객체 타입 선언
    var dateResult = Date(year: 0, month: 0, date: 0)
    
    // 연도 정보 분석
    if let year = Int(param.substring(with: NSRange(location: 0, length: 4))) {
        dateResult.year = year
    } else {
        // 연도 분석 오류
        throw DateParseError.incorrectFormat(part: "year")
    }
    
    // 월 정보 분석
    if let month = Int(param.substring(with: NSRange(location: 5, length: 2))) {
        // 월에 대한 값은 1 ~ 12까지만 가능하므로 그 이외의 범위는 잘못된 값으로 처리한다.
        guard month > 0 && month < 13 else {
            throw DateParseError.incorrectData(part: "month")
        }
        dateResult.month = month
    } else {
        // 월 분석 오류
        throw DateParseError.incorrectFormat(part: "month")
    }
    
    // 일 정보 분석
    if let date = Int(param.substring(with: NSRange(location: 8, length: 2))) {
        // 일에 대한 값은 1 ~ 31까지만 가능하므로 그 이외의 범위는 잘못된 값으로 처리한다.
        guard date > 0 && date < 32 else {
            throw DateParseError.incorrectData(part: "date")
        }
        dateResult.date = date
    } else {
        // 일 분석 오류
        throw DateParseError.incorrectFormat(part: "date")
    }
    
    return dateResult
}

let date = try parseDate(param: "2020-02-28")
```

parseDate 함수를 호출하는 과정에서 문제가 없으면 Date 객체가 잘 대입이 된다. 대신 throws 가 붙은 함수나 메소드를 호출할 때는 반드시 앞에 try 키워드를 붙여주어야 하고 try 만으로는 오류를 잡을 수 없어서 catch 구문을 사용해야 한다.

## 오류 객체 잡아내기

객체를 던지고 잡는 부분은 다른 언어와 비슷한데, 형태는 다음과 같다.

```swift
do {
  try <오류를 던질 수 있는 함수>
} catch <오류타입1> {
  
} catch <오류타입2>
...
```

특이한 점은 스위프트에는 finally 등과 같이 에러가 발생했을 때 반드시 실행되는 코드 블록을 지원하지 않는다는 점이다. 이 부분만 주의한다면 다른 언어와 비슷한 양상을 보인다. 마지막 예시 코드를 작성하고, 스위프트 문법편을 끝낸다.

```swift
func getPartsDat(date: NSString, type: String) {
    do {
        let date = try parseDate(param: date)
        
        switch type {
        case "year":
            print("\(date.year)년입니다.")
        case "month":
            print("\(date.month)월입니다.")
        case "date":
            print("\(date.date)일입니다.")
        default:
            print("입력값에 해당하는 날짜정보가 없습니다")
        }
    } catch  DateParseError.overSizeString {
        print("입력된 문자열이 너무 깁니다. 줄여주세요")
    } catch  DateParseError.underSizeString {
        print("입력된 문자열이 불충분합니다. 늘려주세요")
    } catch  DateParseError.incorrectFormat(let part) {
        print("입력값의 \(part)에 해당하는 형식이 잘못되었습니다.")
    } catch  DateParseError.incorrectData(let part) {
        print("입력값의 \(part)에 해당하는 값이 잘못사용되었습니다. 확인해주세요")
    } catch {
        print("알 수 없는 오류가 발생하였습니다.")
    }
}

getPartsDate(date: "2015-12-31", type: "year")
getPartsDate(date: "2015-13-31", type: "month")
```

