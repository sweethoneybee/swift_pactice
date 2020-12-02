var cities = ["Seoul", "New York", "LA", "Santiago"]
let length = cities.count

for row in cities {
    let index = cities.firstIndex(of: row) // .index(of:) 는 deprecated 되었음. 대신 firstIndex(of:)를 사용
    print("\(index)번째 배열 원소는 \(row)입니다.")
}

var list = [String]()
if list.isEmpty {
    print("배열이 비어있는 상태입니다")
} else {
    print ("배열에는 \(list.count)개의 아이템이 저장되어 있습니다.")
}

cities = [String]()

cities.append("Seoul")
cities.append("New York")
cities.insert("Tokyo", at: 1)
cities.append(contentsOf: ["Dubai", "Sydney"])

var alphabet = ["a", "b", "c", "d", "e"]
alphabet[0...2]
alphabet[2..<4]

alphabet[1...2] = ["1", "2", "3", "4"]
alphabet
alphabet[2...4] = ["A"]
alphabet
