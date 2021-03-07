//
//  main.swift
//  Algorithm
//
//  Created by 정성훈 on 2021/03/06.
//

import Foundation

let N = readLine()
var A = readLine()!.components(separatedBy: " ").map{ Int($0)! }
var B = readLine()!.components(separatedBy: " ").map{ Int($0)! }

A.sort(by: <)
B.sort(by: >)

var S = 0
for i in 0..<A.count {
    S += (A[i] * B[i])
}

print(S)
