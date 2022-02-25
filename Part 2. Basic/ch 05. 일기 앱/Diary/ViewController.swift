import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    
    // diaryList에 추가된 내용을 CollectionView에 표시 되도록 하는 코드
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    // WriteDiaryViewController에서 delegate로 넘겨준 Diary 값을 받을 준비
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDirayViewController {
            // self 를 대입시켜줘서 delegate 를 위임을 받는다..?
            writeDiaryViewController.delegate = self
        }
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

extension ViewController: WriteDiaryViewDelegate {
    func didSelectReigster(diary: Diary) {
        // Diary에 등록되어 넘어온 내용들을, diaryList에 추가되게 된다.
        self.diaryList.append(diary)
        // 일기가 추가될 때마다, reload를 통해 일기 목록이 표시됨
        self.collectionView.reloadData()
    }
}
