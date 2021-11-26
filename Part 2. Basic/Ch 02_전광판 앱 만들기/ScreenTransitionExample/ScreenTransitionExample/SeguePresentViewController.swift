//
//  SeguePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by 서광용 on 2021/09/27.
//

import UIKit

class SeguePresentViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // Back 버튼을 눌렀을 때, 이전 화면으로 돌아가도록
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
