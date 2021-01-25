import UIKit

public enum CSButtonType {
    case rect
    case circle
}

class CSButton: UIButton {
    // 스토리보드 방식으로 커스텀
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // 스토리보드 방식으로 버튼을 정의했을 때 적용됨
        self.backgroundColor = .green
        self.layer.borderWidth = 2 // 테두리는 조금 두껍게
        self.layer.borderColor = UIColor.black.cgColor // 테두리는 검은색으로
        self.setTitle("버튼", for: .normal) // 기본 문구 설정
    }
    
    // 프로그래밍 방식으로 커스텀
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray // 배경을 회색으로
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.setTitle("코드로 생성된 버튼", for: .normal)
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    convenience init(type: CSButtonType) {
        self.init()
        
        switch type {
        
        case .rect :
            self.backgroundColor = .black
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 2
            self.layer.cornerRadius = 0 // 모서리는 전혀 둥글지 않게
            self.setTitleColor(.white, for: .normal) // 글씨는 흰색으로
            self.setTitle("Rect Button", for: .normal) // 기본문구설정
        case .circle :
            self.backgroundColor = .red
            self.layer.borderColor = UIColor.blue.cgColor
            self.layer.borderWidth = 2
            self.layer.cornerRadius = 50 // 50만큼 둥글게 처리
            self.setTitle("Rect Button", for: .normal) // 기본문구설정
        }
    }
    
    var style: CSButtonType = .rect {
        didSet {
            switch style {
            
            case .rect :
                self.backgroundColor = .black
                self.layer.borderColor = UIColor.black.cgColor
                self.layer.borderWidth = 2
                self.layer.cornerRadius = 0 // 모서리는 전혀 둥글지 않게
                self.setTitleColor(.white, for: .normal) // 글씨는 흰색으로
                self.setTitle("Rect Button", for: .normal) // 기본문구설정
            case .circle :
                self.backgroundColor = .red
                self.layer.borderColor = UIColor.blue.cgColor
                self.layer.borderWidth = 2
                self.layer.cornerRadius = 50 // 50만큼 둥글게 처리
                self.setTitle("Rect Button", for: .normal) // 기본문구설정
            }
        }
    }
}
