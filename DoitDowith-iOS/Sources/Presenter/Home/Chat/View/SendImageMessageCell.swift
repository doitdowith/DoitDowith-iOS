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
  func configure(time: String, message: String, image: UIImage) {
    self.dateLabel.text = time
    self.sendImageView.image = image
  }
}
