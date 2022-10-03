//
//  ContentCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import UIKit

final class ContentCell: UICollectionViewCell {
  static let identifier: String = "contentCell"
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var background: UIView!
  @IBOutlet weak var enterButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configureBackgroundView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.titleLabel.text = ""
    self.subtitleLabel.text = ""
  }
}

extension ContentCell {
  func configureBackgroundView() {
    self.background.layer.masksToBounds = true
    self.background.layer.cornerRadius = 8
  }
  
  func configure(title: String, subtitle: String) {
    self.titleLabel.text = title
    self.subtitleLabel.text = subtitle
  }
}
