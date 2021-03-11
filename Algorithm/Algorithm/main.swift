//
//  main.swift
//  Algorithm
//
//  Created by 정성훈 on 2021/03/11.
//

import Foundation

func combination(originalPool: [Character], charPool: inout Set<Character>, startIndex: Int, answer: inout Int) {
    // 여기 수정
    if charPool.count >= K {
        let wordCount = canReadWordCount(charPool: &charPool)
        if wordCount < answer {
            answer = wordCount
        }
        return
    } else {
        for i in startIndex..<originalPool.count {
            charPool.insert(originalPool[i])
            combination(originalPool: originalPool, charPool: &charPool, startIndex: startIndex + 1, answer: &answer)
            charPool.remove(originalPool[i])
        }
    }
}

func canReadWordCount(charPool: inout Set<Character>) -> Int {
    var count = 0
    wordLoop: for word in words { // global variable
        for char in word {
            if charPool.contains(char) == false {
              continue wordLoop
            }
        }
        count += 1
    }
    print("count=\(count)")
    return count
}

func makeOriginalPool(words: [String]) -> Array<Character> {
    var originalPool = Set<Character>()
    
    for word in words {
        for char in word {
            originalPool.insert(char)
        }
    }
    return Array(originalPool)
}

var input = readLine()!.components(separatedBy: " ").map{ Int($0)! }
var N = input[0]
var K = input[1]
var words = [String]()

for _ in 0..<N {
    words.append(readLine()!)
}


let originalPool = makeOriginalPool(words: words)
var charPool: Set<Character> = ["a", "c", "i", "n", "t"]
var answer = 10000000

combination(originalPool: originalPool, charPool: &charPool, startIndex: 0, answer: &answer)

print(answer)

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
