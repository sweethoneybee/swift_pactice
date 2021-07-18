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

// URL
var url = URL(string: "https://developer.apple.com/documentation/foundation/url")!

url.appendPathComponent("Jeong") // https://developer.apple.com/documentation/foundation/url/Jeong
url.appendPathComponent("Seong", isDirectory: true) // https://developer.apple.com/documentation/foundation/url/Jeong/Seong/
url.appendPathExtension("txt") // https://developer.apple.com/documentation/foundation/url/Jeong/Seong.txt/

url.absoluteString // https://developer.apple.com/documentation/foundation/url/Jeong/Seong.txt/
url.absoluteURL // https://developer.apple.com/documentation/foundation/url/Jeong/Seong.txt/
url.baseURL // nil
url.host // developer.apple.com

url.path // /documentation/foundation/url/Jeong/Seong.txt/
url.pathComponents // ["/", "documentation", "foundation", "url", "Jeong", "Seong.txt"]
url.pathExtension // txt
url.lastPathComponent // Seong.txt
url.scheme // https
