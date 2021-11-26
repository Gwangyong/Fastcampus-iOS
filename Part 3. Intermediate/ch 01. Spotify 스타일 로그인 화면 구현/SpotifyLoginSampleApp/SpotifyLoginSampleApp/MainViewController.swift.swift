 //
//  MainViewController.swift.swift
//  SpotifyLoginSampleApp
//
//  Created by 서광용 on 2021/11/23.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 스와이프나 뒤로가기가 되면 안되므로, 방지해주는 코드
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        // Firebase애 로그인하면, User의 email을 가져올 수 있음. 만약 없다면 "고객"이라고 표시
        let email = Auth.auth().currentUser?.email ?? "고객"
        welcomeLabel.text = """
        \(email)님
        환영합니다.
        """
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do {
            // 오류가 발생할 수 있는 코드는 try문을 사용해주어야함.
            // try문에서 로그아웃을 시도하고, 로그아웃되면 RootViewController로 이동
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError{
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
        
        
        
    }
}
