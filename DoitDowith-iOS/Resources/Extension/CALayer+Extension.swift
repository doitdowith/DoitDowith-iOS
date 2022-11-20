//
//  CALayer+Extension.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/29.
//

import UIKit

extension CALayer {
  func applySketchShadow(
    alpha: Float,
    x: CGFloat,
    y: CGFloat,
    blur: CGFloat,
    spread: CGFloat
  ) {
    masksToBounds = false
    shadowColor = UIColor.black.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / UIScreen.main.scale
    if spread == 0 {
      shadowPath = nil
    } else {
      let rect = bounds.insetBy(dx: -spread, dy: -spread)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
  func applySketchShadow(
    color: UIColor,
    x: CGFloat,
    y: CGFloat,
    blur: CGFloat,
    spread: CGFloat
  ) {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / UIScreen.main.scale
    if spread == 0 {
      shadowPath = nil
    } else {
      let rect = bounds.insetBy(dx: -spread, dy: -spread)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
