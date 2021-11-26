//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 서광용 on 2021/11/23.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    // LoginViewController와 동일한 이유로 주석
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        navigationController?.navigationBar.isHidden = false
//    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 30
        
        // 처음에 버튼을 누를 수 없도록 비활성화. (밑에 textFieldDidEndEditing 함수에 활성화되도록 정의)
        nextButton.isEnabled = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // 화면 옮기자마자 커서가 바로 원하는 TextField로 이동하도록
        emailTextField.becomeFirstResponder()
        
        // navigationBar Item의 Title 색상을 white로 변경 (구글링)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // Firebase Email/Password 인증
        // 만약 빈 값이라면, 옵셔널 처리를 해줌. (이게 ?? "" 부분에 대한 설명인거같으니 알아보자)
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // createUser(신규 사용자 생성) <- Firebase 인증 플랫폼에 전달 가능
        // Closure내에서 결과 값을 받음 (authResult, error을 받음)
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입된 계정일 때
                    self.loginUser(withEmail: email, password: password)
                default: // 그 외의 오류에는 에러 Desc
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else { // 오류가 나지 않으면 showMain
                self.showMainViewController()
            }
        }
    }
    
    // storyboard에서 연결해주지 않은 MainViewController을 코드로 연결
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
    // 로그인
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _ , error in
            guard let self = self else { return }
            
            // 에러가 날 경우
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else { // 에러가 나지 않으면 Main으로 이동
                self.showMainViewController()
            }
        }
    }
}

// Delegate를 사용하기 위해
extension EnterEmailViewController: UITextFieldDelegate {
    // 글 작성(endEditing)이 끝나면 내려주는 코드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // 텍스트 작성이 끝났을 경우,
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Email과 Password가 비어있지 않으면, nextButton 버튼이 활성화되도록
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}
