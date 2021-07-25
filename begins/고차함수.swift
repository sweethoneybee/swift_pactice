import Foundation

var arr = [0, 1, 2, 3, 4, 5]

var mapArr = arr.map { Double($0) }
print(mapArr)
// func map<U>(transform: (T) -> U) -> Array<U>
// 함수를 인자로 받는다. 그 함수는 기존 배열 타입 T를 인자로 받아서 타입 U의 아이템을 뱉는다.
// 뱉어진 타입 U로 새로운 배열을 만든다.

var filterArr = arr.filter { $0 % 2 == 0 }
print(filterArr)
// func filter(includeElement: (T) -> Bool) -> Array<T>
// 함수를 인자로 받는다. 그 함수는 기존 배열 타입 T를 인자로 하나씩 받고, Bool을 반환한다.
// 그 Bool 값이 True인 타입 T 아이템에 대해서만 새로운 배열을 만들어서 리턴한다.

var reduceArr = arr.reduce(-1) { $0 + $1 }
print(reduceArr)
// 배열의 각 항목들을 재귀적으로 클로저를 적용시켜 하나의 값을 만든다.
// 첫 번째 인자로 initial value를 받는다.
// 두 번째 인자로 함수를 받는다. 그 함수는 전 클로저의 연산값을 첫 번째 인자로 받고, 각 아이템을 두 번째 인자로 받는다.
// 함수에 대한 연산 결과가, 다음 함수의 첫 번째 인자가 되는 셈이다.
