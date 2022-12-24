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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    profileImageView.image = nil
    nameLabel.text = ""
    receiveMessageTextView.text = ""
    receiveTimeLabel.text = ""
  }
}

extension ReceiveMessageWithProfileCell {
  func configure(image: ImageType?, name: String, message: String?, time: String) {
    if let image = image {
      switch image {
      case .url(let model):
        profileImageView.setImage(with: model)
      case .base64(let model):
        if let data = Data(base64Encoded: model, options: .ignoreUnknownCharacters) {
          let decodedImg = UIImage(data: data)
          profileImageView.image = decodedImg
        }
      }
    }
    
    if let message = message {
      receiveMessageTextView.text = message
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
