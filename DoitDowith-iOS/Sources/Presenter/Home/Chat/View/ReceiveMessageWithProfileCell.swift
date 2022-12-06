//
//  ReceiveMessageWithProfileCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/02.
//

import UIKit
import Kingfisher

class ReceiveMessageWithProfileCell: UITableViewCell {
  static let identifier: String = "ReceiveMessageWithProfileCell"
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var messageView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var receiveMessageTextView: UITextView!
  @IBOutlet weak var receiveTimeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configureMessageView()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    profileImageView.image = nil
    nameLabel.text = ""
    receiveMessageTextView.text = ""
    receiveTimeLabel.text = ""
  }
}

extension ReceiveMessageWithProfileCell {
  func configure(image: Image, name: String, message: Message, time: String) {
    switch image {
    case .url(let model):
      profileImageView.setImage(with: model)
    case .image(let model):
      profileImageView.image = model
    }
    
    switch message {
    case .text(let model):
      receiveMessageTextView.text = model
    case .image:
      break
    }
    nameLabel.text = name
    receiveTimeLabel.text = time
  }
  
  func configureMessageView() {
    messageView.layer.applySketchShadow(alpha: 0.04, x: 2, y: 2, blur: 4, spread: 0)
    messageView.layer.cornerRadius = 2
    addTipView()
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
