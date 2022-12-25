//
//  String+.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/22.
//

import Foundation

extension String {
  func toDate() -> Date? { // "yyyy-MM-dd"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    if let date = dateFormatter.date(from: self) {
      return date
    } else {
      return nil
    }
  }
  
  func substring(from: Int, to: Int) -> String {
      guard from < count, to >= 0, to - from >= 0 else {
          return ""
      }
      // Index 값 획득
      let startIndex = index(self.startIndex, offsetBy: from)
      let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
      
      // 파싱
      return String(self[startIndex ..< endIndex])
  }
}
