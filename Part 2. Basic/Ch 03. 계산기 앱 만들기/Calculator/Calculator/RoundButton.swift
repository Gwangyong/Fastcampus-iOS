//
//  RoundButton.swift
//  Calculator
//
//  Created by 서광용 on 2021/10/17.
//

import UIKit

@IBDesignable   // 실시간으로 사용가능하도록
class RoundButton: UIButton {
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
