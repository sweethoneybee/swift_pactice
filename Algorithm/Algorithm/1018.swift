//
//  main.swift
//  Algorithm
//
//  Created by 정성훈 on 2021/03/06.
//

import Foundation


let input = readLine()!.components(separatedBy: " ")
var N = Int(input[0])!
var M = Int(input[1])!

var board = [String]()
for _ in 0..<N {
    board.append(readLine()!)
}

var answer = 10000000
for x in 0...N-8 {
    for y in 0...M-8 {
        let cuttedBoardCount = countReColoring(startX: x, startY:y)
        answer = min(answer, cuttedBoardCount)
    }
}

print(answer)

func countReColoring(startX: Int, startY: Int) -> Int {
    let startWithW = colorStart(with: "W", startX: startX, startY: startY)
    let startWithB = colorStart(with: "B", startX: startX, startY: startY)
    return min(startWithW, startWithB)
}

func colorStart(with rightColor: Character, startX: Int, startY: Int) -> Int {
    var count = 0
    for x in startX..<(startX+8) {
        for y in startY..<(startY+8) {
            if x % 2 == 0 && y % 2 == 0 {
                if board[x][y] == rightColor {
                    count += 1
                }
            } else if x % 2 == 1 && y % 2 == 1 {
                if board[x][y] == rightColor {
                    count += 1
                }
            } else {
                if board[x][y] != rightColor {
                    count += 1
                }
            }
        }
    }
    return count
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}


