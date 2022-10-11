//
//  UIApplication+Extension.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/11.
//

import Foundation
import UIKit

extension UIApplication {
  static var safeAreaEdgeInsets: UIEdgeInsets {
    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    return scene?.windows.first?.safeAreaInsets ?? .zero
  }
}
