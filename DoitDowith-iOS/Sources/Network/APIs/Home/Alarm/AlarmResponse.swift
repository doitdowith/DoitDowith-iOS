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
  var category: String
  var name: String
  var date: String
}

extension AlarmResponse {
  var toDomain: [Alarm] {
    return data.map { (alarm: AlarmData) -> Alarm in
      var title = ""
      var date = ""
      if alarm.category == "ROOM" {
        title = "\(alarm.name)님이 방에 초대했어요!"
        date = alarm.date
      } else if alarm.category == "FRIEND" {
        title = "\(alarm.name)님이 친구를 추가했어요!"
        date = alarm.date
      }
      return Alarm(title: title, date: date)
    }
  }
}
