//
//  UILabel+Extension.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/06.
//

import UIKit

extension UILabel {
  var width: CGFloat {
    return frame.size.width
  }
  var height: CGFloat {
    return frame.size.height
  }
  var left: CGFloat {
    return frame.origin.x
  }
  var right: CGFloat {
    return left + width
  }
  var top: CGFloat {
    return frame.origin.y
  }
  var bottom: CGFloat {
    return top + height
  }
}
