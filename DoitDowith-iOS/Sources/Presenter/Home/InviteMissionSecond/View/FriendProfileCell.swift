//
//  FriendProfileCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/13.
//

import UIKit

class FriendProfileCell: UICollectionViewCell {
  static let identifier: String = "FriendProfileCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configureBackgroundView()
  }
  override func prepareForReuse() {
    super.prepareForReuse()
  }
}

extension FriendProfileCell {
  func configureBackgroundView() {
    self.layer.masksToBounds = true
    self.layer.cornerRadius = 24
    self.layer.applySketchShadow(alpha: 0.16, x: 1, y: 1, blur: 2, spread: 0)
  }
}
