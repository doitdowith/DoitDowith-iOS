//
//  UIView+.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/08.
//

import Foundation
import UIKit

extension UIView {
  func addBackground(with name: String) {
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    imageViewBackground.image = UIImage(named: name)
    imageViewBackground.contentMode = .scaleAspectFill
    
    self.addSubview(imageViewBackground)
    self.sendSubviewToBack(imageViewBackground)
  }
}
