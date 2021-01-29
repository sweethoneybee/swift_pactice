import UIKit
class RevealViewController: UIViewController {
    var contentVC: UIViewController? // 콘텐츠를 담당할 뷰 컨트롤러
    var sideVC: UIViewController? // 사이드 바 메뉴를 담당핣 뷰 컨트롤러
    
    var isSideBarShowing = false // 현재 사이드 바가 열려있는지 여부
    
    let SLIDE_TIME = 0.3 // 사이드 바가 열리고 닫히는 데 걸리는 시간
    let SIDEBAR_WIDTH: CGFloat = 260 // 사이드 바가 열릴 너비
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    // 초기 화면을 설정한다.
    func setUpView() {
        // 1. _프론트 컨트롤러 객체를 읽어온다
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_front") as? UINavigationController {
            // 2. 읽어온 컨트롤러를 클래스 전체에서 참조할 수 있도록 contentVC 속성에 저장한다.
            self.contentVC = vc
            // 3. _프론트 컨트롤러 객체를 메인 컨트롤러의 자식으로 등록한다.
            self.addChild(vc) // _프론트 컨트롤러를 메인 컨트롤러의 자식 뷰 컨트롤러로 등록
            self.view.addSubview(vc.view) // _프론트 컨트롤러의 뷰를 메인 컨트롤러의 서브 뷰로 등록
            // _프론트 컨트롤러에 부모 뷰 컨트롤러가 바뀌었음을 알려준다.
            vc.didMove(toParent: self)
            
            // 4. 프론트 컨트롤러의 델리게이트 변수에 참조 정보를 넣어준다
            let frontVC = vc.viewControllers[0] as? FrontViewContrller
            frontVC?.delegate = self
        }
    }
    
    // 사이드 바의 뷰를 읽어온다
    func getSideView() {
        guard self.sideVC == nil else {
            return
        }
        
        // 1. 사이드 바 컨트롤러 객체를 읽어온다.
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_rear") else {
            return
        }
        
        // 2. 다른 메소드에서도 참조할 수 있도록 sideVC 속성에 저장한다
        self.sideVC = vc
        
        // 3. 읽어온 사이드 바 컨트롤러 객체를 컨테이너 뷰 컨트롤러에 연결한다
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        // 4. 사이드 바 컨트롤러에 부모 뷰 컨트롤러가 바뀌었음을 알려준다
        vc.didMove(toParent: self)
        
        // 5. _프론트 컨트롤러의 뷰를 제일 위로 올린다
        self.view.bringSubviewToFront((self.contentVC?.view)!)
    }
    
    // 콘텐츠 뷰에 그림자 효과를 준다
    func setShadowEffect(shadow: Bool, offSet: CGFloat) {
        if (shadow == true) {
            self.contentVC?.view.layer.masksToBounds = false
            self.contentVC?.view.layer.cornerRadius = 10 // 그림자 모서리 둥글기
            self.contentVC?.view.layer.shadowOpacity = 0.8 // 그림자 투명도
            self.contentVC?.view.layer.shadowColor = UIColor.black.cgColor // 그림자 색상
            self.contentVC?.view.layer.shadowOffset = CGSize(width: offSet, height: offSet) // 그림자 크기
        } else {
            self.contentVC?.view.layer.cornerRadius = 0.0
            self.contentVC?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    
    // 사이드 바를 연다
    func openSideBar(_ complete: (() -> Void)?) {
        // 1. 앞에서 정의했던 메소드들을 실행
        self.getSideView() // 사이드 바 뷰를 읽어온다
        self.setShadowEffect(shadow: true, offSet: -2) // 그림자 효과를 준다
        // 2. 애니메이션 옵션
        let options = UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState])
        // 3. 애니메이션 실행
        UIView.animate(
            withDuration: TimeInterval(self.SLIDE_TIME),
            delay: TimeInterval(0),
            options: options,
            animations: {
                self.contentVC?.view.frame = CGRect(x: self.SIDEBAR_WIDTH, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            },
            completion: {
                if $0 == true {
                    self.isSideBarShowing = true // 열림 상태로 플래그를 변경한다.
                    complete?()
                }
            })
    }
    
    // 사이드 바를 닫는다
    func closeSideBar(_ complete: (() -> Void)?) {
        // 애니메이션 옵션을 정의한다.
        let options = UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState])
        // 애니메이션 실행
        UIView.animate(
            withDuration: TimeInterval(self.SLIDE_TIME),
            delay: TimeInterval(0),
            options: options,
            animations: {
                // 1. 옆으로 밀려난 콘텐츠 뷰의 위츠를 제자리로
                self.contentVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            },
            completion: {
                if $0 == true {
                    // 2. 사이드 바 뷰를 제거한다
                    self.sideVC?.view.removeFromSuperview()
                    self.sideVC = nil
                    // 3. 닫힘 상태로 플래그를 변경한다
                    self.isSideBarShowing = false
                    // 4. 그림자 효과를 제거한다
                    self.setShadowEffect(shadow: false, offSet: 0   )
                    // 5. 인자값으로 입력받은 완료 함수를 실행한다.
                    complete?()
                }
            })
    }
}
