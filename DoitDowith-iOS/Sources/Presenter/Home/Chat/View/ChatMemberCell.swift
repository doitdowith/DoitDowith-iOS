//
//  ChatMemberCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/23.
//

import UIKit
import Kingfisher

class ChatMemberCell: UITableViewCell {
  static let identifier: String = "ChatMemberCell"
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.profileImageView.image = nil
    self.nameLabel.text = ""
  }
}

extension ChatMemberCell {
  func configure(model: Participant) {
    let image = model.profileImage
    self.profileImageView.setImage(with: "http://117.17.198.38:8080/images/\(image)")
    self.nameLabel.text = model.name
  }
}
