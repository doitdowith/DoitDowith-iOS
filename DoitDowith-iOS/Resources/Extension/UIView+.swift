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
  
  func showToast(message: String, width: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
    let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width / 2 - (width / 2),
                                           y: self.frame.size.height - 200, width: width, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10
    toastLabel.clipsToBounds  =  true
    self.addSubview(toastLabel)
    UIView.animate(withDuration: 8.0, delay: 0.1, options: .curveEaseOut, animations: {
      toastLabel.alpha = 0.0
    }, completion: {_ in
      toastLabel.removeFromSuperview()
    })
  }
}
