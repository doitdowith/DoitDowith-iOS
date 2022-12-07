//
//  FriendProfileCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/13.
//

import UIKit
import Kingfisher

class FriendProfileCell: UICollectionViewCell {
  static let identifier: String = "FriendProfileCell"
  
  @IBOutlet weak var profileImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profileImage.clipsToBounds = true
    profileImage.layer.cornerRadius = self.contentView.frame.height / 2
    profileImage.layer.applySketchShadow(alpha: 0.16, x: 1, y: 1, blur: 2, spread: 0)
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    self.profileImage.image = nil
  }
}

extension FriendProfileCell {
  func configure(url: String) {
    let processor = RoundCornerImageProcessor(cornerRadius: 24)
    self.profileImage.kf.setImage(with: URL(string: url), options: [.processor(processor)])
  }
}
