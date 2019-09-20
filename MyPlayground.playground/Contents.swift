//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import SnapKit

protocol X {
    associatedtype XX
    var beta: XX { get }
}

class MyViewController : UIViewController, X {
    let label = UILabel()
    let button = UIButton(type: .system)
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello World!"
        label.textColor = .black
        
        button.setTitle("Hello", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(button)
        self.view = view
        
        button.addTarget(self, action: #selector(buttonTap(_:)), for: .primaryActionTriggered)
        
        stored.apply()
    }
    
    @objc
    func buttonTap(_ sender: UIResponder) {
        UIView.animate(withDuration: 1.0) {
            self.opt.toggle()
            self.view.setNeedsUpdateConstraints()
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    var opt = true
    
    lazy var stored: XX = beta

    var beta: some DSL {
        return Build {
            label.snp.top == view.snp.top
            if opt {
                label.snp.left == view.snp.left + 10.0
            } else {
                label.snp.left == view.snp.left
                button.snp.right == view.snp.right
            }
            button.snp.top == label.snp.bottom
            button.snp.left == label.snp.left
        }
    }
    
    override func updateViewConstraints() {
        let new = beta
        new.update(stored)
        stored = new
        super.updateViewConstraints()
        
        print(view.constraints)
    }
}
// Present the view controller in the Live View window
let vc = MyViewController()
PlaygroundPage.current.liveView = vc

print(vc.view.constraints)

