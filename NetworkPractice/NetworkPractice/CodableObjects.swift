//
//  CodableObjects.swift
//  NetworkPractice
//
//  Created by 정성훈 on 2021/04/02.
//

import Foundation

struct Article: Codable {
    var id: String
    var featured: Bool
    var title: String
    var url: String
    var imageUrl: String
    var newsSite: String
    var summary: String
    var publishedAt: String // ?
    var launches: [Launch]
    var events: [Event]
}

struct Launch: Codable {
    var id: String
    var provider: String
}

struct Event: Codable {
    var id: String
    var provide: String
}

