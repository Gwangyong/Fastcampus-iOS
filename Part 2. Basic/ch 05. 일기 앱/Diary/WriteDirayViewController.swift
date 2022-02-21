import UIKit

class WriteDirayViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var dirayDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
    }
    

    
    // 내용의 TextView 테두리 색상등 설정
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/250, green: 220/250, blue: 220/250, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker() {
        // 시간은 필요 없으니, 날짜만 표시되도록 .date
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        // addTarget는 UI 컨트롤러 객체가 이벤트에 응답하는 방식을 설정해주는 메소드
        // 해당 뷰 컨트롤러에 해당되니 첫 매개변수는 self임
        // datePickerValueDidChange가 값이 바뀔 때마다 datePickerValueDidChage가 호출됨
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.dateTextField.inputView = self.datePicker
        
    }
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter()
        // E를 5번 적으면, 요일을 한 글자만 표현하게 할 수 있다함.
        formmater.dateFormat = "yyyy년 mm월 dd일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        self.dirayDate = datePicker.date
        self.dateTextField.text = formmater.string(from: datePicker.date)
    }
    
    // 날짜 wheels에서 정하다가, 비어있는 화면들을 누르면 키보드가 내려가도록 하는 코드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
