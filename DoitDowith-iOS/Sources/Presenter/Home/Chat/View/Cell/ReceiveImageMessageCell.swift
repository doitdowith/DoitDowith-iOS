//
//  ReceiveImageMessageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/17.
//

import UIKit

class ReceiveImageMessageCell: UITableViewCell {
  static let identifier: String = "ReceiveImagemessageCell"
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var receiveImageView: UIImageView!
  @IBOutlet weak var receiveMessageView: UIView!
  @IBOutlet weak var receiveMessage: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    self.layer.applySketchShadow(alpha: 0.04,
                                 x: 2,
                                 y: 2,
                                 blur: 4,
                                 spread: 0)
    self.layer.cornerRadius = 2
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.dateLabel.text = ""
    self.receiveImageView.image = nil
  }
}

extension ReceiveImageMessageCell {
  func configure(time: String, message: String?, image: ImageType?) {
    if let image = image {
      switch image {
      case .url(let model):
        receiveImageView.setImage(with: model)
      case .base64(let model):
        if let data = Data(base64Encoded: model, options: .ignoreUnknownCharacters) {
          let decodedImg = UIImage(data: data)
          receiveImageView.image = decodedImg
        }
      }
    }
    
    if let message = message {
      receiveMessage.text = message
    }
    self.dateLabel.text = time
  }
}
