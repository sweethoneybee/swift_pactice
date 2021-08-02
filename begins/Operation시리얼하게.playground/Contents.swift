import Foundation

class MyOperation: Operation {

    /*
     concurrent operation 일 때 구현해야 함. super.start() 는 절대 호출하지 않는다
     start()는 스스로 실행할 수 있는지 상태체크도 해야하고, 메인도 콜해주어야한다.
     operation의 상태도 추적해야하고, 적절한 상태 변화도 제공해야한다.
     또한 operation이 실행되고 적절한 일들을 마치고 나면, isExecuting과 isFinished에 대한
     KVO 노티를 각각 발급해줘야한다.
     커스텀할 여지는 많지만 그만큼 신경쓸 게 많음
     */
//    override func start() {
//        print("시작!!")
//        main()
//    }
    var number: Int?
    
    convenience init(number: Int) {
        self.init()
        self.number = number
    }
    
    override init() {
        super.init()
    }
    
    override func main() {
        print("여기가 \(number!)번째 메인이고, 오래 돌 것임")
        for _ in 0..<1000000 {
            continue
        }
    }
}

var queue = OperationQueue()
queue.maxConcurrentOperationCount = 1 // serial한 처리를 위해서

for i in 0..<10 {
    let op = MyOperation(number: i)
    op.completionBlock = {
        print("여기는 \(i)번째 컴플리션 핸들러!")
    }
    queue.addOperation(op)
}


