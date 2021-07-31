import Foundation

let queue = OperationQueue()


/*
 동시 실행 값은 defaultMaxConcurrentOperationCount에 의해서 결정됨.
 defaultMaxConcurrentOperationCount값은 현재 시스템의 상태에 따라서 동적으로 결정됨
 */
//queue.maxConcurrentOperationCount = 1

let operation1 = BlockOperation { // Operation 상속 받음. 걍 블록 추가하고, 조회하는 프로퍼티만 추가됨
    print("한번 만들어본 오퍼레이션! 안 쓸 거야!")
}

for i in 0..<100 {
    queue.addOperation { // 큐에 오퍼레이션 추가하면 시스템이 시작 가능하면 바로 시작함
        print("\(i)번째 오퍼레이션!")
    }
    print("\(i)번째 추가 완료!")
}


var operationsArray = [Operation]()
for i in 0..<100 {
    operationsArray.append(BlockOperation {
        print("블록오퍼레이션 \(i)번째!")
    })
}

operationsArray.forEach { operation in
    queue.addOperation(operation)
    print("추가됐지롱")
}

// 여러 개의 스레드에서 하나의 OperationQueue에 접근하는 것은, 따로 락을 걸지 않아도 안전함이 보장된다.
// == OpeartionQueue는 스레드 세이프!
