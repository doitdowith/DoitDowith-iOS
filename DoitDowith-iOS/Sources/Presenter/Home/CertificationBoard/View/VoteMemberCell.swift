//
//  VoteMemberCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/02.
//

import UIKit
import Kingfisher

class VoteMemberCell: UICollectionViewCell {
  static let identifier: String = "VoteMemberCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.nickName.text = ""
    self.profileImage.image = nil
    self.emojiImage.image = nil
  }
  
  @IBOutlet weak var nickName: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var emojiImage: UIImageView!
}

extension VoteMemberCell {
  func configure(with model: VoteMember) {
    self.nickName.text = model.nickName
    if let url = model.profileImageUrl {
      let processor = RoundCornerImageProcessor(cornerRadius: 18)
      self.profileImage.kf.setImage(with: URL(string: url), options: [.processor(processor)])
    }
    if let url = model.emojiUrl {
      let processor = RoundCornerImageProcessor(cornerRadius: 18)
      self.emojiImage.kf.setImage(with: URL(string: url), options: [.processor(processor)])
    }
  }
}
