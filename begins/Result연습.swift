import Foundation

struct Person {
    var name: String
    var age: Int
}

enum RegistError: Error {
    case unknownError
    case unValidNameError
    case unValidAgeError
    case notPersonError
}

typealias RegistCompletion = (Result<Person, RegistError>) -> (Void)

func register(name: String?, age: Int?, completion: RegistCompletion) {
    guard let name = name else {
        completion(.failure(.unValidNameError))
        return
    }
    guard let age = age, age > 0 else {
        completion(.failure(.unValidAgeError))
        return
    }

    let person = Person(name: name, age: age)
    
    // some instruct with data
    if true { // an error occur
        completion(.failure(.unknownError))
        return
    } 

    completion(.success(person))
}

register(name: "Jeong", age: 25) { result in
    switch result {
        case .failure(let error):
            print("failure!")
            print("error=\(error)")
        case .success(let person):
            print("success!")
            print("result=\(person)")
    }
}
