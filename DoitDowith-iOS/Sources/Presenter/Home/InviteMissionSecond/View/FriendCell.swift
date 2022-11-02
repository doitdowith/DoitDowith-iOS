//
//  FriendCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/13.
//

import UIKit

class FriendCell: UITableViewCell {
  static let identifier: String = "FriendCell"
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var inviteStateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.profileImage.image = nil
    self.nameLabel.text = ""
    self.inviteStateLabel.text = ""
  }
}

extension FriendCell {
  func configure(name: String, state: String) {
    self.nameLabel.text = name
    self.inviteStateLabel.text = state
  }
}
