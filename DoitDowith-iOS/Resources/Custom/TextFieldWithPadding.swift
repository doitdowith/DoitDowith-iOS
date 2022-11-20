//
//  UIPaddingTextField.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/10.
//

import Foundation
import UIKit

@IBDesignable
class UITextFieldWithPadding: UITextField {
  @IBInspectable var topInsect: CGFloat = 0
  @IBInspectable var leftInsect: CGFloat = 0
  @IBInspectable var bottomInsect: CGFloat = 0
  @IBInspectable var rightInsect: CGFloat = 0
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: UIEdgeInsets(top: topInsect,
                                       left: leftInsect,
                                       bottom: bottomInsect,
                                       right: rightInsect))
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.editingRect(forBounds: bounds)
    return rect.inset(by: UIEdgeInsets(top: topInsect,
                                       left: leftInsect,
                                       bottom: bottomInsect,
                                       right: rightInsect))
  }
}
