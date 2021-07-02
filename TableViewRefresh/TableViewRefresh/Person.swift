//
//  User.swift
//  TableViewRefresh
//
//  Created by 정성훈 on 2021/06/28.
//

import Foundation

struct Person {
    var profileImageURL: URL
    var name: String
    var description: String
    
    static func makeMockData() -> [Person] {
        var persons = [Person]()
        
        for i in 0..<30 {
            let person = Person(profileImageURL: URL(string: (ApiProvider.baseUrl + "\(i).jpg"))!, name: "(\(i) 나의 이름)", description: "이것은 나의 설명입니다. 길게 적지 않겠습니다.")
            persons.append(person)
        }
        return persons
    }
}
