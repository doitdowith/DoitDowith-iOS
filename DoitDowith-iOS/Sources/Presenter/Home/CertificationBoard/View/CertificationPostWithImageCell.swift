//
//  CertificationPostWithImageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/23.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources
import Kingfisher

protocol CertificationPostWithImageCellDelegate: AnyObject {
  func certificationPostWithImageCell(_ voteButtonDidTap: UIButton)
}

class CertificationPostWithImageCell: UICollectionViewCell {
  static let identifier: String = "CertificationPostWithImageCell"
  weak var delegate: CertificationPostWithImageCellDelegate?
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nickName: UILabel!
  @IBOutlet weak var uploadTime: UILabel!
  @IBOutlet weak var certificateImage: UIImageView!
  @IBOutlet weak var certificateText: UILabel!
  
  @IBAction func voteButtonDidTap(_ sender: UIButton) {
    self.delegate?.certificationPostWithImageCell(sender)
  }
  
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.profileImage.image = nil
    self.nickName.text = ""
    self.uploadTime.text = ""
    self.certificateImage.image = nil
    self.certificateText.text = ""
  }
}

extension CertificationPostWithImageCell {
  func configure(with model: CertificationPost) {
    self.nickName.text = model.nickName
    self.uploadTime.text = model.uploadTime
    self.certificateText.text = model.certificateText
    
    let processor = RoundCornerImageProcessor(cornerRadius: 18)
    if let profileImageUrl = model.profileImageUrl {
      self.profileImage.setImage(with: "http://117.17.198.38:8080/images/\(profileImageUrl)",
                                 processor: processor)
    }
    
    if let certificateImageUrl = model.certificateImageUrl,
       let data = Data(base64Encoded: certificateImageUrl, options: .ignoreUnknownCharacters) {
      let certificateImage = UIImage(data: data)
      self.certificateImage.image = certificateImage
    }
  }
}
