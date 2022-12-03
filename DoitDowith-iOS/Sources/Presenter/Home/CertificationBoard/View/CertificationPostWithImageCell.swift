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
    self.uploadTime.text = model.uploadTime.formatted()
    self.certificateText.text = model.certificateText
    if let url = model.profileImageUrl {
      let processor = RoundCornerImageProcessor(cornerRadius: 18)
      self.profileImage.kf.setImage(with: URL(string: url), options: [.processor(processor)])
    }
    if let url = model.certificateImageUrl {
      let width = UIScreen.main.bounds.width
      let processor = ResizingImageProcessor(referenceSize: CGSize(width: width - 56, height: 220))
      self.certificateImage.kf.setImage(with: URL(string: url), options: [.processor(processor)])
    }
  }
}
