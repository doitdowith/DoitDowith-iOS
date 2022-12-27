//
//  ContentCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import UIKit

final class CardCell: UICollectionViewCell {
  static let identifier: String = "CardCell"
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var background: UIView!
  @IBOutlet weak var enterButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  
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

extension CardCell {
  func configureBackgroundView() {
    self.background.layer.masksToBounds = true
    self.background.layer.cornerRadius = 8
  }
  
  func configure(model: Card) {
    self.titleLabel.text = model.title
    self.subtitleLabel.text = model.description
    if let hex = Int(model.color) {
      let color = UIColor(hex: hex)
      self.background.backgroundColor = color
    }
    if let date = model.startDate.toDate() {
      let nextDate = date.addingTimeInterval(3600 * 24 * 7)
      self.dateLabel.text = "\(date.formatted(format: "yyyy년 MM월 dd일")) ~ \(nextDate.formatted(format: "yyyy년 MM월 dd일"))"
    }
  }
}
