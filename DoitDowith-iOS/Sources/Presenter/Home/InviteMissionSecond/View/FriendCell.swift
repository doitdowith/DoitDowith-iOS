//
//  FriendCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/13.
//

import UIKit
import Kingfisher

class FriendCell: UITableViewCell {
  static let identifier: String = "FriendCell"
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var inviteStateLabel: UILabel!
  var state: State?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.profileImage.layer.applySketchShadow(alpha: 0.16,
                                              x: 1,
                                              y: 1,
                                              blur: 2,
                                              spread: 0)
    self.profileImage.layer.cornerRadius = profileImage.frame.height / 2
    self.profileImage.clipsToBounds = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.profileImage.image = nil
    self.nameLabel.text = ""
    self.inviteStateLabel.text = ""
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let bottomSpace: CGFloat = 2.0 // Let's assume the space you want is 10
    self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0))
  }
}

extension FriendCell {
  func configure(url: String, name: String, state: State) {
    let processor = RoundCornerImageProcessor(cornerRadius: 22)
    self.profileImage.kf.setImage(with: URL(string: url), options: [.processor(processor)])
   
    self.nameLabel.text = name
    self.state = state
    switch state {
    case .can:
      self.inviteStateLabel.text = State.can.rawValue
      self.inviteStateLabel.textColor = UIColor(red: 95/255,
                                                green: 212/255,
                                                blue: 156/255,
                                                alpha: 1)
    case .fail:
      self.inviteStateLabel.text = State.fail.rawValue
      self.inviteStateLabel.textColor = UIColor(red: 112/255,
                                                green: 165/255,
                                                blue: 244/255,
                                                alpha: 1)
    case .ing:
      break
    }
  }
}
