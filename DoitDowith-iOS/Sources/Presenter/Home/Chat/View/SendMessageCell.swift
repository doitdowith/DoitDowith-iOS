//
//  SendMessageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import UIKit

class SendMessageCell: UITableViewCell {
  static let identifier: String = "SendMessageCell"
  
  @IBOutlet weak var messageView: UIView!
  @IBOutlet weak var sendMessageTextView: UITextView!
  @IBOutlet weak var sendTimeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    messageView.layer.applySketchShadow(alpha: 0.04, x: 2, y: 2, blur: 4, spread: 0)
    messageView.layer.cornerRadius = 2
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    sendMessageTextView.text = ""
    sendTimeLabel.text = ""
  }
}

// Configure
extension SendMessageCell {
  func configure(time: String, message: String) {
    sendMessageTextView.text = message
    sendTimeLabel.text = time
  }
  
  func addTipView() {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: self.messageView.bounds.width, y: 0)) // 시작 위치
    path.addLine(to: CGPoint(x: self.messageView.bounds.width + 6.5, y: 0))
    path.addLine(to: CGPoint(x: self.messageView.bounds.width, y: 6.5))
    path.addLine(to: CGPoint(x: self.messageView.bounds.width, y: 0))
    let shape = CAShapeLayer()
    shape.cornerRadius = 2
    shape.path = path
    shape.fillColor = UIColor(red: 186/255, green: 211/255, blue: 249/255, alpha: 1).cgColor
    self.messageView.layer.insertSublayer(shape, at: 0)
    self.messageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
}
