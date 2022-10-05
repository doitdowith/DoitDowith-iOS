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
  func configure(time: String, message: String) {
    receiveMessageTextView.text = message
    receiveTimeLabel.text = time
  }
  
  func addTipView() {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 0, y: 0)) // 시작 위치
    path.addLine(to: CGPoint(x: -6.5, y: 0))
    path.addLine(to: CGPoint(x: 0, y: 6.5))
    path.addLine(to: CGPoint(x: 0, y: 0))
    let shape = CAShapeLayer()
    shape.cornerRadius = 2
    shape.path = path
    shape.fillColor = UIColor.white.cgColor
    self.messageView.layer.insertSublayer(shape, at: 0)
    self.messageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
  }
}
