//
//  AlarmResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/27.
//

import Foundation

struct AlarmResponse: Decodable {
  var data: [AlarmData]
  
}

struct AlarmData: Decodable {
  var title: String
  var date: String
}

extension AlarmResponse {
  var toDomain: [Alarm] {
    return data.map { Alarm(title: $0.title, date: $0.date) }
  }
}
