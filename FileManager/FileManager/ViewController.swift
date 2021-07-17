//
//  ViewController.swift
//  FileManager
//
//  Created by 정성훈 on 2021/07/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onMakeFileButton() {
        self.makeFile()
    }
    
    @IBAction func onMakeDirButton() {
        self.makeDir()
    }
    
    @IBAction func onMakeFileToDirButton() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("jeong")
        
        self.makeFile(documentsURL: documentsURL)
    }
    
    private func makeFile(documentsURL: URL? = nil) {
        let text = NSString(string: "이런 곳에서 일해볼 수 있다니 난 정말 좋은 기회를 얻었어")
        if let documentsURL = documentsURL {
            let fileURL = documentsURL.appendingPathComponent("jeong의 파일.txt")
            write(text: text, toPath: fileURL)
        } else {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            let fileURL = documentsURL.appendingPathComponent("jeong의 파일.txt")
            write(text: text, toPath: fileURL)
        }
    }
    
    private func write(text: NSString?, toPath path: URL?) {
        guard let text = text, let path = path else {
            NSLog("유효하지 않은 파일 내용 혹은 경로입니다")
            return
        }
        
        do {
            try text.write(to: path, atomically: true, encoding: String.Encoding.utf8.rawValue)
            NSLog("파일 write 성공")
        } catch {
            NSLog("파일 write 실패")
        }
        
    }
    
    private func makeDir() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let filePath = documentsURL.appendingPathComponent("jeong")
            
        if !fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                NSLog("디렉토리 생성 성공")
            } catch {
                NSLog("document 디렉토리를 만들 수 없습니다")
            }
        }
    }
    
    

}

