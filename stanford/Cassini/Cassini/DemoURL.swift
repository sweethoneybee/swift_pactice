//
//  DemoURL.swift
//  Cassini
//
//  Created by 정성훈 on 2021/03/12.
//

import Foundation

struct DemoURL {
    static let person = "https://img.sbs.co.kr/newimg/news/20201105/201488059_1280.jpg"
    
    static let NASA = [
        "Cassini": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Cassini_Saturn_Orbit_Insertion.jpg/1200px-Cassini_Saturn_Orbit_Insertion.jpg",
        "Earth": "https://www.nasa.gov/sites/default/files/thumbnails/image/annotated_earth-moon_from_saturn_1920x1080.jpg",
        "Saturn": "https://www.nasa.gov/sites/default/files/styles/full_width_feature/public/thumbnails/image/pia12567-1600.jpg",
    ]
    
    static func NASAImageNamed(imageName: String?) -> URL? {
        if let urlstring = NASA[imageName ?? ""] {
            return URL(string: urlstring)
        } else {
            return nil
        }
    }
}
