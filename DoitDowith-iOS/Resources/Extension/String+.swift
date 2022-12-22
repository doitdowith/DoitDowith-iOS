//
//  String+.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/22.
//

import Foundation

extension String {
  func toDate() -> Date? { //"yyyy-MM-dd"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    if let date = dateFormatter.date(from: self) {
      return date
    } else {
      return nil
    }
  }
}
