import UIKit

class DiaryCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // 이 생성자는 UIView가 xib나 storyboard 에서 생성이 될 때, 이 생성자를 통해 객체가 생성됨
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // cell의 테두리를 그려주는 코드
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
