//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by 서광용 on 2021/09/27.
//

import UIKit

// SendDataDelegate 라는 protocol을 생성
protocol SendDataDelegate: AnyObject {
    func sendData(name: String)
}

class CodePresentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    weak var delegate: SendDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.delegate?.sendData(name: "Jud")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
