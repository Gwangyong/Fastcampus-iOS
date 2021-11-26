//
//  LoginViewController.swift.swift
//  SpotifyLoginSampleApp
//
//  Created by 서광용 on 2021/11/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 3개 버튼에 동일한 UI 테두리가 생기도록
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    // viewWillArrer: 이제 뷰가 나타날 것이다. (View Controller 생명주기)
    // 강의에서는 해주어야 하지만, 업데이트되서 그런지 안해줘도 네비게이션바는 어느정도 자동으로 되서 주석처리.
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Navigation Bar 숨기기
//        navigationController?.navigationBar.isHidden = true
//    }
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        // Firebase 인증
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        // Firebase 인증
    }
    
}
