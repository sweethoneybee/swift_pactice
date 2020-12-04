var capital = ["KR":"Seoul", "EN":"London", "FR":"Paris"]
capital["KR"]
capital["EN"]
capital["FR"]

var newCapital = [String:String]()
newCapital["JP"] = "Tokyo"

if newCapital.isEmpty {
    print("딕셔너리가 비어있는 상태입니다.")
} else {
    print("딕셔너리의 크기는 현재 \(newCapital.count)입니다")
}

// #딕셔너리 값 추가
// .updateValue(_:forKey:)는 기존에 저장되어있는 키가 있으면 연결된 값을 수정하는 역할을 하고,
// 새로운 키가 입력되면 아이템을 추가하는 역할도 수행
// 리턴값은 수정하기 이전의 값이 리턴됨
// 그래서 완전 새로운 걸 삽입할 때는 nil이 리턴됨
newCapital.updateValue("Seoul", forKey: "KR")
newCapital.updateValue("London", forKey: "EN")
newCapital.updateValue("Sapporo", forKey: "JP")

// #딕셔너리 값 제거
newCapital.updateValue("Ottawa", forKey: "CA")
newCapital.updateValue("Beijing", forKey: "CN")

// 방법1. 값에 nil을 대입하면 삭제됨
// nil 반환
newCapital["CN"] = nil

// 방법2. removeValue(forKey:) 메소드 활용
// 삭제된 아이템의 값 반환
if let removedValue = newCapital.removeValue(forKey: "CA") {
    print("삭제된 값은 \(removedValue)입니다.")
} else {
    print("아무 것도 삭제되지 않았습니다.")
}

//딕셔너리로부터 키를 호출해서 저장된 값을 불러올 때 없는 키를 호출했을 가능성을 항상 염두에 두어야 함.
//이 경우를 처리해 줄 수 있어야 안전한 프로그래밍 언어가 된다고 함.
//그래서 스위프트에서는 키 호출 접근시, 업데이트 메소드 실행결과 반환시 오류 발생을 염두에 두어
//Optional("Sapporo") 와 같은 형식으로 값을 반환함
//Optional은 이후에 학습예정

// #딕셔너리 순회 탐색
for row in newCapital {
    let (key, value) = row
    print("현재 데이터는 \(key) : \(value)입니다.")
}
for (key, value) in newCapital {
    print("현재 데이터는 \(key) : \(value)입니다.")
}
