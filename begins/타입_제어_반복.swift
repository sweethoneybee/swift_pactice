print("Hello world!")

var age : Int = 24
let name : String = "정성훈"
print("제 이름은 \(name)입니다. 제 올해 나이는 \(age)살이며 내년에 나이는 \(age + 1)살 입니다.")

if age >= 25 {
  print("이십대 중반이군요")
}
else if age > 20 && age < 25 {
  print("이십대 초반이군요")
}
else {
  print("이십대 초중반에 아무데도 안 속하군요!")
}

let num : Int = 3
for _ in 1...3 {
  print("이 문장은 \(num)번 반복됩니다")
}

print("1부터 4까지 출력해보겠습니다")
for i in 1..<5 {
  print(i)
}

//guard false else {
//  print("guard가 false면 출력됩니다")
// fallthrough 이기 때문에 guard는 따로 쓰지 않습니다.
//}

tempLabel : while true {
  let i : Int = 0
  print("\(i)번째 무한 루프입니다")
  for j in 1...5 {
    print("무한루프 안에서 이중반복문. \(j)번째입니다")
    
    if j == 4 {
      break tempLabel
    }
  }
  print("이 문장은 출력되면 안됩니다")
}

repeat {
  print("반복문 일단 실행하고 조건 보기. do while 문 같이")
} while false
