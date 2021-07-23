//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    private var observers = [NSKeyValueObservation]()
    private let viewModel = ViewModel()
    
    let stepper: UIStepper = {
        $0.minimumValue = 0
        $0.stepValue = 1
        $0.maximumValue = 10
        $0.value = 0
        $0.addTarget(self, action: #selector(stepperValueChange(_:)), for: .valueChanged)
        return $0
    }(UIStepper())
    
    @objc func stepperValueChange(_ sender: UIStepper) {
        viewModel.count = Int(sender.value)
    }

    let label: UILabel = {
        $0.textColor = .black
        return $0
    }(UILabel())
    
    func initObservers() {
        observers.append(viewModel.observe(\.count, options: [.initial, .new]) { object, change in
        guard let newValue = change.newValue else { return }
            self.label.text = "\(newValue)개"
        })
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        view.addSubview(label)
        
        stepper.frame = CGRect(x: 50, y: 50, width: 100, height: 50)
        view.addSubview(stepper)
        
        self.view = view
        
        initObservers()
    }
}

class ViewModel: NSObject {
    @objc dynamic var count = 0
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

