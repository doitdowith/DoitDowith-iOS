//
//  SendImageMessageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/17.
//

import UIKit

class SendImageMessageCell: UITableViewCell {
  static let identifier: String = "SendImageMessageCell"
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var sendMessageView: UIView!
  @IBOutlet weak var sendImageView: UIImageView!
  @IBOutlet weak var sendMessage: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
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
    self.sendImageView.image = nil
  }
}

extension SendImageMessageCell {
  func configure(time: String, message: String?, image: ImageType?) {
    if let image = image {
      switch image {
      case .url(let model):
        sendImageView.setImage(with: model)
      case .base64(let model):
        if let data = Data(base64Encoded: model, options: .ignoreUnknownCharacters) {
          let decodedImg = UIImage(data: data)
          sendImageView.image = decodedImg
        }
      }
    }
    
    if let message = message {
      sendMessage.text = message
    }
    
    self.dateLabel.text = time
  }
}
