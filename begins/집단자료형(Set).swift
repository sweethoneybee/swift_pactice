var genres : Set = ["Classic", "Balad", "Rock"]
var g : Set<String> = []

g.insert("Classic")
g.insert("Rock")
g.insert("Balad")

for g in genres.sorted() {
    print(g)
}

// 여기는 아마 String?(Optional) 이 리턴값이라 이렇게 해도 되는 듯..?
// if let temp : String? = "wow" 랑 같은 느낌인데 뭔가 다른 것 같기도 하구..
if let removedItem = genres.remove("Rock") {
    print("아이템 \(removedItem)의 삭제가 완료되었습니다")
} else {
    print("삭제할 값이 집합에 추가되어 있지 않습니다.")
}

if (genres.remove("Rock") != nil) {
    print("아이템의 삭제가 완료되었습니다")
} else {
    print("삭제할 값이 집합에 추가되어 있지 않습니다.")
}


var oddDigits : Set = [1, 3, 5, 7, 9]
let evenDigits : Set = [0, 2, 4, 6, 8]
let primeDigits : Set = [2, 3, 5, 7]

oddDigits.intersection(evenDigits).sorted()
oddDigits.symmetricDifference(primeDigits).sorted()
oddDigits.union(evenDigits).sorted()

oddDigits.subtract(primeDigits)
oddDigits.sorted()

let A : Set = [1, 3, 5, 7, 9]
let B : Set = [3, 5]
let C : Set = [3, 5]
let D : Set = [2, 4, 6]

B.isSubset(of: A)
A.isSuperset(of: B)
C.isStrictSubset(of: A)
C.isStrictSubset(of: B)
A.isDisjoint(with: D)

// 배열의 중복을 Set을 활용해 없애기
var a = [4, 2, 5, 1, 7, 4, 9, 11, 3, 5, 4]
//let b = Set(a)
//a = Array(b)
a = Array(Set(a))

