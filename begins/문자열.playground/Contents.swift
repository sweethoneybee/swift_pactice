import Foundation

let str = "https://news.jtbc.joins.com/html/493/NB12016493.html"
let keyword = "html"
if let range = str.range(of: keyword) {
    let newStr = str[..<range.upperBound]
    
    print("기존 문장=\(str)")
    print("범위까지 문장=\(newStr)")
    
    let slicedStr = str[range]
    print("범위대로 자른 문장=\(slicedStr)")
}
