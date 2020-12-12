func isHansu(_ n: Int) -> Bool {
    var num = n
    
    if num < 100 {
        return true
    }
    
    if num == 1000 {
        return false
    }
    
    var nums = Array<Int>()
    while num > 0 {
        nums.append(num % 10)
        num /= 10
    }
    
    let gap = nums[0] - nums[1]
    if gap == nums[1] - nums[2] {
        return true
    }
    
    return false
}

var input = Int(readLine()!)!
var hansuFlag = Array(repeating: 0, count: input + 1)

let len = hansuFlag.count
var answer = 0
for i in 1..<len {
    if isHansu(i) {
        hansuFlag[i] = 1
        answer += 1
    }
}

print(answer)
