////
////  main.swift
////  Algorithm
////
////  Created by 정성훈 on 2021/03/11.
////
//
import Foundation

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

var funcCount = 0
func combination(originalPool: [Character], charPool: inout Set<Character>, startIndex: Int, answer: inout Int) {
    funcCount += 1
    if charPool.count >= K {
        let wordCount = canReadWordCount(charPool: &charPool)
        if wordCount > answer {
            answer = wordCount
        }
        return
    } else {
        for i in startIndex..<originalPool.count {
            charPool.insert(originalPool[i])
            combination(originalPool: originalPool, charPool: &charPool, startIndex: i + 1, answer: &answer)
            charPool.remove(originalPool[i])
        }
        return
    }
}

var loopCount = 0
func canReadWordCount(charPool: inout Set<Character>) -> Int {
    var count = 0
    wordLoop: for word in words { // global variable
        for char in word[word.index(word.startIndex, offsetBy: 4)...word.index(word.endIndex, offsetBy: -5)] {
            loopCount += 1
            if charPool.contains(char) == false {
              continue wordLoop
            }
        }
        count += 1
    }
    return count
}

func makeOriginalPool(words: [String]) -> Array<Character> {
    var originalPool: Array<Character> = ["a", "c", "i", "n", "t"]

    var pool = Set(originalPool)
    for word in words {
        for char in word {
            if pool.contains(char) == false {
                pool.insert(char)
                originalPool.append(char)
            }
        }
    }

    return originalPool
}

var input = readLine()!.components(separatedBy: " ").map{ Int($0)! }
var N = input[0]
var K = input[1]
var words = [String]()

for _ in 0..<N {
    words.append(readLine()!)
}

var answer = 0

if K >= 5 {
    let originalPool = makeOriginalPool(words: words)
    if originalPool.count > K {
        var charPool: Set<Character> = ["a", "c", "i", "n", "t"]
        combination(originalPool: originalPool, charPool: &charPool, startIndex: 5, answer: &answer)
    }
}

print(answer)
