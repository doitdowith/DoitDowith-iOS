//
//  ImageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/03.
//

import UIKit

class ImageCell: UICollectionViewCell {
  static let identifier: String = "ImageCell"
    
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageView.image = nil
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var imageView: UIImageView!
  
  func configure(image: UIImage) {
    self.imageView.image = image
  }
}
