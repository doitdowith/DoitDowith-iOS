//
//  ReceiveImageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/23.
//

import UIKit

class ReceiveImageCell: UITableViewCell {
  static let identifier: String = "ReceiveImageCell"
  
  @IBOutlet weak var receiveDateLabel: UILabel!
  @IBOutlet weak var receiveImageView: UIImageView!
  
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
    self.receiveDateLabel.text = ""
    self.receiveImageView.image = nil
  }
}

extension ReceiveImageCell {
  func configure(time: String, image: String?) {
    if let image = image,
       let data = Data(base64Encoded: image, options: .ignoreUnknownCharacters) {
      let decodedImg = UIImage(data: data)
      receiveImageView.image = decodedImg
    }
    self.receiveDateLabel.text = time
  }
}
