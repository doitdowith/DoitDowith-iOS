//
//  CertificationPostCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/24.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources
import Kingfisher

protocol CertifiactionPostCellDelegate: AnyObject {
  func certificationPostCell(_ voteButtonDidTap: UIButton)
}

class CertificationPostCell: UICollectionViewCell {
  static let identifier: String = "CertificationPostCell"
  weak var delegate: CertifiactionPostCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.profileImage.layer.applySketchShadow(alpha: 0.16,
                                              x: 1,
                                              y: 1,
                                              blur: 2,
                                              spread: 0)
    self.profileImage.layer.cornerRadius = 18
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nickName: UILabel!
  @IBOutlet weak var uploadTime: UILabel!
  @IBOutlet weak var certificateText: UILabel!
  
  @IBAction func voteButtonDidTap(_ sender: UIButton) {
    self.delegate?.certificationPostCell(sender)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.profileImage.image = nil
    self.nickName.text = ""
    self.uploadTime.text = ""
    self.certificateText.text = ""
  }
}

extension CertificationPostCell {
  func configure(with model: CertificationPost) {
    self.nickName.text = model.nickName
    self.uploadTime.text = model.uploadTime
    self.certificateText.text = model.certificateText
    let processor = RoundCornerImageProcessor(cornerRadius: 18)
    if let profileImageUrl = model.profileImageUrl {
      self.profileImage.setImage(with: "http://117.17.198.38:8080/images/\(profileImageUrl)",
                                 processor: processor)
    }
  }
}
