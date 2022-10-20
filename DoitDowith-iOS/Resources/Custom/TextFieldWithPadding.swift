//
//  UIPaddingTextField.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/10.
//

import Foundation
import UIKit

@IBDesignable
class TextFieldWithPadding: UITextField {
  @IBInspectable var topInsect: CGFloat = 0
  @IBInspectable var leftInsect: CGFloat = 0
  @IBInspectable var bottomInsect: CGFloat = 0
  @IBInspectable var rightInsect: CGFloat = 0
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: topInsect,
                                         left: leftInsect,
                                         bottom: bottomInsect,
                                         right: rightInsect))
  }
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: topInsect,
                                         left: leftInsect,
                                         bottom: bottomInsect,
                                         right: rightInsect))
  }
//  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//    return bounds.inset(by: UIEdgeInsets(top: topInsect,
//                                         left: leftInsect,
//                                         bottom: bottomInsect,
//                                         right: rightInsect))
// }
}
