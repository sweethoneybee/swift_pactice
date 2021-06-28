//
//  User.swift
//  TableViewRefresh
//
//  Created by 정성훈 on 2021/06/28.
//

import Foundation

struct User {
    var profileImageURL: URL
    var name: String
    var description: String
    
    static func makeMockData() -> [User] {
        var users = [User]()
        
        for i in 0..<30 {
            let user = User(profileImageURL: URL(string: (ApiProvider.baseUrl + "\(i).jpg"))!, name: "(\(i) 나의 이름)", description: "이것은 나의 설명입니다. 길게 적지 않겠습니다.")
            users.append(user)
        }
        return users
    }
}
