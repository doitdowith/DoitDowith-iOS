//
//  ReceiveMessageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import UIKit

class ReceiveMessageCell: UITableViewCell {
  static let identifier: String = "ReceiveMessageCell"
  
  @IBOutlet weak var messageView: UIView!
  @IBOutlet weak var receiveMessageTextView: UITextView!
  @IBOutlet weak var receiveTimeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    messageView.layer.applySketchShadow(alpha: 0.04, x: 2, y: 2, blur: 4, spread: 0)
    messageView.layer.cornerRadius = 2
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    receiveMessageTextView.text = ""
    receiveTimeLabel.text = ""
  }
}

// Configure
extension ReceiveMessageCell {
  func configure(time: String, message: String?) {
    if let message = message {
      receiveMessageTextView.text = message
    }
    receiveTimeLabel.text = time
  }
}
