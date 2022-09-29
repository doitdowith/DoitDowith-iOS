//
//  Date+Extension.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/29.
//

import Foundation
extension Date {
  /**
   # formatted
   - Note: 오후, 오전으로 변형한 String 반환
   */
  public func formatted(format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: self)
  }
}
