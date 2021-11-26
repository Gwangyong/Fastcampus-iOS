//
//  SeguePushViewController.swift
//  ScreenTransitionExample
//
//  Created by 서광용 on 2021/09/27.
//

import UIKit

class SeguePushViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var name: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
                self.nameLabel.text = name
                self.nameLabel.sizeToFit()
        }
    }
    
    // 스택의 pop 형식으로 뒤로 돌아갈 수 있도록
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    // 바로 전 화면이 아닌, rootViewController로 돌아가는 방법
//        self.navigationController?.popToRootViewController(animated: true)
    }
}
