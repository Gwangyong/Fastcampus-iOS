import UIKit

class WriteDirayViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
    }
    
    // 내용의 TextView 테두리 색상등 설정
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/250, green: 220/250, blue: 220/250, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
    }
}
