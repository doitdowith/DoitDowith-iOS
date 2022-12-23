//
//  ChatMemberCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/23.
//

import UIKit
import Kingfisher

class ChatMemberCell: UITableViewCell {
//  @IBOutlet weak var profileImageView: UIImageView!
//  @IBOutlet weak var name: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
//    self.profileImageView.image = nil
  }
}
//
//extension ChatMemberCell {
//  func configure(model: Participant) {
//    let image = model.profileImage
//    self.profileImageView.setImage(with: image)
//    self.name.text = model.name
//  }
//}
