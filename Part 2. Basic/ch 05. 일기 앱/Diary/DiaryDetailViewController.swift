import UIKit


class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    var starButton: UIBarButtonItem?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        // star 버튼을 생성. starButton 이 눌리면, selector 함수가 호출
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    
    // 위의 configureView에서 dateLabel에 값을 넣어줄 때, Data 값이기 때문에, String으로 formatter을 해줌
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        self.diary = diary
        self.configureView()
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDirayViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditorMode = .edit(indexPath, diary)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteDiary"),
            object: indexPath,
            userInfo: nil
        )
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapStarButton() {
        guard let isStar = self.diary?.isStar else { return }
        guard let indexPath = indexPath else { return }

        if isStar { // 버튼을 눌렀는데 true였으면 일반 star로
            self.starButton?.image = UIImage(systemName: "star")
        } else { // 버튼을 눌렀는데 false였다면 색칠된 star로
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        // 눌렀으니 !를 사용하여 반대값을 보내줌
        self.diary?.isStar = !isStar
        // 즐겨찾기에 값을 보내줘야 하므로, Delegate를 사용해서 즐겨찾기가 되어있는지와, indexPath를 보냄
        NotificationCenter.default.post(
            name: NSNotification.Name("starDiary"),
            object: [
                "isStar": self.diary?.isStar ?? false,
                "indexPath": indexPath
            ],
            userInfo: nil
        )
    }
    
    // 인스턴스가 deinit 될 때, 추가된 옵저버를 모두 삭제
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


