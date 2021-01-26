import UIKit

@IBDesignable
public class CSStepper: UIView {
    
    public var leftBtn = UIButton(type: .system) // 좌측버튼
    public var rightBtn = UIButton(type: .system) // 우측버튼
    public var centerLabel = UILabel() // 중앙 레이블
    // 스테퍼의 현재값을 저장할 변수
    public var value: Int = 0 {
        didSet { // 프로퍼티의 값이 바뀌면 자동으로 호출된다
            self.centerLabel.text = String(value)
        }
    }
    
    // 스토리보드에서 호출할 초기화 메소드
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // 프로그래밍방식으로 호출할 초기화 메소드
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        
        let borderWidth: CGFloat = 0.5 // 테두리 두께값
        let borderColor = UIColor.blue.cgColor // 테두리 색상값
        
        // 좌측 다운 버튼 속성 설정
        self.leftBtn.tag = -1 // 태그값에 -1을 부여
        self.leftBtn.setTitle("↓", for: .normal) // 버튼의 타이틀
        self.leftBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.leftBtn.layer.borderWidth = borderWidth // 버튼 테두리 두께
        self.leftBtn.layer.borderColor = borderColor // 버튼 테두리 색상 - 파란색
        
        // 우측 업 버튼 속성 설정
        self.rightBtn.tag = 1 // 태그값에 1을 부여
        self.rightBtn.setTitle("↑", for: .normal)
        self.rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.rightBtn.layer.borderWidth = borderWidth // 버튼 테두리 두께
        self.rightBtn.layer.borderColor = borderColor // 버튼 테두리 색상 - 파란색
        
        // 중앙 레이블 속성 설정
        self.centerLabel.text = String(value) // 컨트롤의 현재값을 문자열로 변환하여 표시
        self.centerLabel.font = UIFont.systemFont(ofSize: 16)
        self.centerLabel.textAlignment = .center
        self.centerLabel.backgroundColor = .cyan // 배경 색상 지정
        self.centerLabel.layer.borderWidth = borderWidth // 버튼 테두리 두께
        self.centerLabel.layer.borderColor = borderColor // 버튼 테두리 색상 - 파란색
        
        // 영역별 객체를 서브 뷰로 추가한다
        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        self.addSubview(self.centerLabel)
        
        // 버튼의 터치 이벤트와 valueChange(_:) 메소드를 연결한다
        self.leftBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(valueChange(_:)), for: .touchUpInside)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 버튼의 너비 = 뷰 높이
        let btnWidth = self.frame.height
        
        // 레이블의 너비 뷰 = 뷰 전체 크기 - 왼쪽 버튼의 너비 합
        let lblWidth = self.frame.width - (btnWidth * 2)
        
        self.leftBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        self.centerLabel.frame = CGRect(x: btnWidth, y: 0, width: lblWidth, height: btnWidth)
        self.rightBtn.frame = CGRect(x: btnWidth + lblWidth, y: 0, width: btnWidth, height: btnWidth)
    }
    
    // value 속성의 값을 변경하는 메소드
    @objc public func valueChange(_ sender: UIButton) {
        // 현재의 value값에 +1 또는 -1을 한다.
        self.value += sender.tag
    }
}
