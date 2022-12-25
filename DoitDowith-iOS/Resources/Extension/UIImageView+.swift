//
//  UIImageView+.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/05.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
  func setImage(with urlString: String, processor: RoundCornerImageProcessor? = nil) {
    ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
      switch result {
      case .success(let value):
        if let image = value.image {
          // 캐시가 존재하는 경우
          self.image = image
        } else {
          // 캐시가 존재하지 않는 경우
          guard let url = URL(string: urlString) else { return }
          let resource = ImageResource(downloadURL: url, cacheKey: urlString)
          if let processor = processor {
            self.kf.setImage(with: resource, options: [.processor(processor)])
          } else {
            self.kf.setImage(with: resource)
          }
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}
