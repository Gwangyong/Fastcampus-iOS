import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        // 프로퍼티 옵저버를 사용해서, diaryList 배열에 값이 변경될 때 마다 값이 UserDefaults에 저장됨.
        // didSet 옵저버를 사용했기 때문에, 값이 변경된 후에 실행됨
        didSet {
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil)
    }
    
    // diaryList에 추가된 내용을 CollectionView에 표시 되도록 하는 코드
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @objc func editDiaryNotification(_ nofification: Notification) {
        guard let diary = nofification.object as? Diary else { return }
        guard let row = nofification.userInfo?["indexPath.row"] as? Int else { return }
        self.diaryList[row] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    // WriteDiaryViewController에서 delegate로 넘겨준 Diary 값을 받을 준비
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDirayViewController {
            // self 를 대입시켜줘서 delegate 를 위임을 받는다..?
            writeDiaryViewController.delegate = self
        }
    }
    
    private func saveDiaryList() {
        let date = self.diaryList.map {
            [
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        // 아래에서 date는 기본 데이터베이스에 저장할 객체이고, diaryList는 값을 연결할 키이다.
        userDefaults.set(date, forKey: "diaryList")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        // object 메소드는 Any 타입으로 반환하기 때문에, 아래처럼 타입 캐스팅을 해주어야함.
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        self.diaryList = data.compactMap {
            // 불러온 값이 Any 타입이므로, 각각에 맞게 as? 를 사용하여 타입 캐스팅
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        self.diaryList = self.diaryList.sorted(by: {
            // 왼쪽 date값과, 오른쪽 date 값을 비교를 할건데, 그걸 내림차순으로 정렬한다는뜻
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    // 아래에서 dateLabel.text가 그냥 date를 받으면, String이 아니라 date 타입이기 때문에, 여기서 포맷해줌
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter.string(from: date)
    }
}

// CollectionView에서 DataSource는 CollectionView로 보여주는 콘텐츠를 관리하는 객체
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    // cell의 사이즈를 설정하는 역할
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // cell이 행에 2개씩 하게 할거라 / 2를 통해 아이폰 너비를 반으로 나눠줌
        // 또한, contentInset에 설정해준 left, right 간격(각각 10씩) 만큼 제외해줌. 그래서 - 20
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}

extension ViewController: UICollectionViewDelegate {
    // didSelectItemAt은 특정 셀이 선택되었음을 알려주는 주는 메소드
    // 즉, 선택된 셀으로 push
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: WriteDiaryViewDelegate {
    func didSelectReigster(diary: Diary) {
        // Diary에 등록되어 넘어온 내용들을, diaryList에 추가되게 된다.
        self.diaryList.append(diary)
        self.diaryList = self.diaryList.sorted(by: {
            // 왼쪽 date값과, 오른쪽 date 값을 비교를 할건데, 그걸 내림차순으로 정렬한다는뜻
            $0.date.compare($1.date) == .orderedDescending
        })
        // 일기가 추가될 때마다, reload를 통해 일기 목록이 표시됨
        self.collectionView.reloadData()
    }
}

// DiaryDetailViewController의 Delegate를 통해 받은 indexPath로, 삭제 버튼을 눌렀을 경우에 diaryList와 collectionView에서 삭제함
extension ViewController: DiaryDetailViewDelegate {
    func didSelectDelete(indexPath: IndexPath) {
        self.diaryList.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
    }
}
