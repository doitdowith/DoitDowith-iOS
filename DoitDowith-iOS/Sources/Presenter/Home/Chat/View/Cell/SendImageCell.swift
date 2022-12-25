//
//  SendImageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/23.
//

import UIKit

class SendImageCell: UITableViewCell {
  static let identifier: String = "SendImageCell"
  
  @IBOutlet weak var sendDateLabel: UILabel!
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
  override func prepareForReuse() {
    super.prepareForReuse()
    self.sendDateLabel.text = ""
    self.sendImageView.image = nil
  }
}

extension SendImageCell {
  func configure(time: String, image: String?) {
    if let image = image,
       let data = Data(base64Encoded: image, options: .ignoreUnknownCharacters) {
      let decodedImg = UIImage(data: data)
      sendImageView.image = decodedImg
    }
    self.sendDateLabel.text = time
  }
}
