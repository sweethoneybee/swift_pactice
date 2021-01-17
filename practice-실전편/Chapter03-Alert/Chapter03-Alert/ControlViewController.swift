import UIKit

class ControlViewController: UIViewController {
    // 슬라이더 객체를 정의
    let slider = UISlider()
    
    // 슬라이더 객체의 값을 읽어올 연산 프로퍼티
    var sliderValue: Float {
        return self.slider.value
    }
    
    override func viewDidLoad() {
        // 슬라이더의 최소값, 최대값 설정
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        
        // 슬라이더의 영역과 크기를 정의하고 루트 뷰에 추가한다.
        self.slider.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(slider)
        
        // 뷰 컨트롤러의 콘텐츠 사이즈를 지정한다
        self.preferredContentSize = CGSize(width: self.slider.frame.width, height: self.slider.frame.height + 10)
    }
}
