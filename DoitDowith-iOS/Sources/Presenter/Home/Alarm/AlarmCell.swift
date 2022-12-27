//
//  AlarmCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/27.
//

import UIKit

class AlarmCell: UITableViewCell {
  static let identifer: String = "AlarmCell"
  
  @IBOutlet weak var alarmBackgroundView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.alarmBackgroundView.layer.masksToBounds = true
    self.alarmBackgroundView.layer.cornerRadius = 8
    // Initialization code
  }
}

extension AlarmCell {
  func configure(model: Alarm) {
    self.titleLabel.text = model.title
    self.dateLabel.text = model.date
  }
}
