//
//  ColorCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/12.
//

import UIKit

final class ColorCell: UICollectionViewCell {
  static let identifier = "ColorCell"
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
      } else {
        self.layer.borderWidth = 0
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configureBackgroundView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
}

extension ColorCell {
  func configureBackgroundView() {
    self.layer.masksToBounds = true
    self.layer.cornerRadius = 24
    self.layer.applySketchShadow(alpha: 0.16, x: 1, y: 1, blur: 2, spread: 0)
  }
  
  func configure(color: UIColor) {
    self.backgroundColor = color
  }
}
