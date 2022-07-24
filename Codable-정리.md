# Codable

[https://minsone.github.io/programming/swift-codable-and-exceptions-extension](https://minsone.github.io/programming/swift-codable-and-exceptions-extension) 

[https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) 

**위의 글들을 참고하여 정리함**

---

Data encoding, decoding을 위해 Swift 라이브러리가 표준화된 접근을 만든 것이 Codable 프로토콜. Encodable, Decodable을 커스텀 타입에 구현함으로써 Codable을 adopt할 수 있음. JSON이나 property list 같은 external representation 으로 Decode하거나 Encode할 수 있음.

## 자동적으로 Encode, Decode

하나의 Type을 Codable하게 만드는 가장 쉬운 방법은 이미 Codable을 채택하고 있는 properties를 사용하는 것임. 이러한 Types는`String` , `Int`, `Double` 등과 같은 Standard library types를 포함함. Property가 이미 codable을 준수한다면, 그 type은 codable 준수를 명시하는 것만으로도 `Codable`을 준수할 수 있음. 

```swift
struct Landmark: Codable {
    var name: String
    var foundingYear: Int
    
    // Landmark now supports the Codable methods init(from:) and encode(to:), 
    // even though they aren't written as part of its declaration.
}
```

`Landmark` 는 `PropertyListEncoder` 나 `JSONEncoder` 클래스를 사용해서 인코딩 될 수 있음.

Built-in 타입인 `Array`, `Dictionary`, `Optional` 역시 그들이 codable types를 가지고 있다면 Codable을 준수함.

Encoding이나 Decoding만 필요하다면, Codable 준수보다는 Encodable 혹은 Decodable에 대해서만 준수할 수 있음.

## Coding Keys를 사용해서 Encod하고 Decode할 프로퍼티를 고르기

Codable 타입들은 `CodingKeys` 라는 **Special nested enumeration** 을 선언할 수 있음(`CodingKeys`는 CodingKey 프로토콜을 준수함). 이 enumeration이 존재하면 이것의 cases는 codable 타입의 인스턴스가 인코딩 or 디코딩 될 때 반드시 포함되어야하는 프로퍼티의 리스트로 제공됨(대충 반드시 포함되어야한다는 뜻). enumeration cases의 이름은 내가 타입에 지정한 이럼과 동일해야 함.

특정 프로퍼티가 인스턴스를 디코딩할 때 나타나지 않거나, 인코딩된 결과물에 포함되지 않으려면 CodingKeys enumeration에서 프로퍼티를 빼야 함. **CodingKeys에서 빠진 프로퍼티는 Decodable 혹은 Codable을 자동 준수를 받으려면 기본값(default value)가 필요함. (Encodable은 아님을 주목)**

만약에 직렬화된 데이터 포맷에서 사용되는 keys가 데이터 타입의 프로퍼티 이름과 매칭이되지 않는다면, `String` 을 CodingKeys enumeration의 raw-value 타입으로 특정지음으로써 대체의 keys를 제공해라. 각 enumeration case의 raw value로 사용한 string은 인코딩과 디코딩에서 사용될 key name임. case name과 그것의 raw value와의 관계는 우리의 data structures를 Swift API Guideline에 맞추도록 해줌. 직렬화 포맷의 names, punctuation, 대문자화 등등에 관계 없이. 

아래의 예시는 `name` 과 `foundingYear` 프로퍼티에 대해서 alternative keys(대체키..?)를 제공하는 것을 보여줌.

```swift
struct Landmark: Codable {
    var name: String
    var foundingYear: Int
    var location: Coordinate
    var vantagePoints: [Coordinate]
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case foundingYear = "founding_date"
        
        case location
        case vantagePoints
    }
}
```

## Decoder Protocol

3가지 메소드가 있음.

`container(keyedBy:)` : 인자로 제공되는 key type으로 키가 지정된 컨테이너에 표시된 대로 이 디코더에 저장된 데이터를 리턴. ⇒ JSON 형태로 걍 뱉어낸다고 생각하면 됨.

`singleValueContainer()` : 한 가지의 primitive value 를 가지는 데에 적절한 컨테이너에 표시된 대로 이 디코더에 저장된 데이터를 리턴 ⇒ JSON이 같은 타입의 값을 가진 배열인 경우

⇒ `["a", "b", "c]"`와 같은 형태의 데이터

`unkeyedContainer()` : 키가 없는 값들을 가지는 데에 적절한 컨테이너에 표시된 대로 이 디코더에 저장된 데이터를 리턴 ⇒ JSON이 여러 타입으로 된 배열을 내려줄 경우.

⇒ `["a", 1, 10.0, true, "b"]` 와 같은 형태의 데이터
