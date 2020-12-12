func selfNumber(n: Int) -> Int {
    var n = n
    var ret = n
    
    while n > 0 {
        ret += n % 10
        n /= 10
    }
    
    return ret
}

var numberCheck = Array(repeating: 0, count: 10001)


for i in 1...10000 {
    if numberCheck[i] == 0 {
        var index = i
    
        
        while index <= 10000 && numberCheck[index] != 1{
            numberCheck[index] = 1
            index = selfNumber(n: index)
        }
        numberCheck[i] = 0
    }
}

for i in 1...10000 {
    if numberCheck[i] == 0 {
        print(i)
    }
}
