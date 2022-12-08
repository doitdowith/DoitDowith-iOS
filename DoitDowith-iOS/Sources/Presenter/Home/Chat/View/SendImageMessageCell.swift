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
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.dateLabel.text = ""
    self.sendImageView.image = nil
  }
}

extension SendImageMessageCell {
  func configure(time: String, message: Message, image: Image?) {
    if let image = image {
      switch image {
      case .url(let model):
        sendImageView.setImage(with: model)
      case .image(let model):
        sendImageView.image = model
      }
    }
    
    switch message {
    case .text(let model):
      sendMessage.text = model
    case .image:
      break
    }
    self.dateLabel.text = time
  }
}
