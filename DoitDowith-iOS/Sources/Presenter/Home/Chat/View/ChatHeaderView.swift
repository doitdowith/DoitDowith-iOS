//
//  ChatHeaderView.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/02.
//

import UIKit

class ChatHeaderView: UITableViewHeaderFooterView {
  static let identifier: String = "ChatHeaderView"
  
  @IBOutlet weak var dateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    self.dateLabel.text = ""
  }
  func configure(day: String) {
    print("here")
    self.dateLabel.text = day
  }
}
