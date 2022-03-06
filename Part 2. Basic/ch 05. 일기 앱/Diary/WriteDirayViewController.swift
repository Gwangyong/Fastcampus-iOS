import UIKit

enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
    
}

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectReigster(diary: Diary)
}

class WriteDirayViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var dirayDate: Date?
    weak var delegate: WriteDiaryViewDelegate?
    var diaryEditorMode: DiaryEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.configureEditMode()
        // 등록 버튼이 초기에 눌리지 않게끔 해줌
        self.confirmButton.isEnabled = false
    }
    
    private func configureEditMode() {
        switch self.diaryEditorMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.dirayDate = diary.date
            self.confirmButton.title = "수정"
            
        default:
            break
        }
    }
    
    private func dateToString(date: Date) -> String {
        let formattor = DateFormatter()
        formattor.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formattor.locale = Locale(identifier: "ko-KR")
        return formattor.string(from: date)
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
    
    private func configureInputField() {
        self.contentsTextView.delegate = self
        // titleTextField 에 텍스트가 입력될 때마다, titleTextFieldDidChange(_:) 메소드가 호출되도록함
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    // notification Center?
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.dirayDate else { return }

        
        switch self.diaryEditorMode {
        case .new:
            let diary = Diary(
                // 생성할 떄마다 uuid라는 고유한 값을 주게됨
                uuidString: UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: false
            )
            self.delegate?.didSelectReigster(diary: diary)
        
        case let .edit(indexPath, diary):
            let diary = Diary(
                uuidString: UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: diary.isStar
            )
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: nil
            )
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter()
        // E를 5번 적으면, 요일을 한 글자만 표현하게 할 수 있다함.
        formmater.dateFormat = "yyyy년 mm월 dd일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        self.dirayDate = datePicker.date
        self.dateTextField.text = formmater.string(from: datePicker.date)
        // dateTextField가 키보드 입력이 아니여서 dateTextFieldDidChange 메소드가 호출되지 않아서 아래의 코드로 변경될 때마다 Actions를 발생시켜서 호출되도록 함
        self.dateTextField.sendActions(for: .editingChanged)
    }
     
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    // touchesBegan 이라는 터치가 시작될 때 불려지는 함수
    // 날짜 wheels에서 정하다가, 비어있는 화면들을 누르면 키보드가 내려가도록 하는 코드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func validateInputField() {
        // Nil 병합 연산자(??)를 통해서 값이 3가지 전부 비어있지 않으면, 등록 버튼이 활성화 되도록
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}

extension WriteDirayViewController: UITextViewDelegate {
    // TextView의 Text가 입력될 때마다 호출되는 메소드. 즉, 일기 작성 내용들이 입력될 때마다 이 메소드가 출력됨
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
