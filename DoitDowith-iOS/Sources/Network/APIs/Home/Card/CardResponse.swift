//
//  CardResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/12.
//

import Foundation

struct CardResponse: Decodable {
  var doingRoomList, doneRoomList, willDoRoomList: [Room]
}

struct Room: Decodable {
  var color, description, id, title: String
  var startDate: [Int]
}

extension CardResponse {
  var toDomain: [Card] {
    var data: [Card] = []
    for room in doingRoomList {
      data.append(Card(section: 1,
                       roomId: room.id,
                       title: room.title,
                       description: room.description,
                       color: room.color,
                       startDate: "\(room.startDate[0])-\(room.startDate[1])-\(room.startDate[2])"))
    }
    for room in willDoRoomList {
      data.append(Card(section: 2,
                       roomId: room.id,
                       title: room.title,
                       description: room.description,
                       color: room.color,
                       startDate: "\(room.startDate[0])-\(room.startDate[1])-\(room.startDate[2])"))
    }
    for room in doneRoomList {
      data.append(Card(section: 3,
                       roomId: room.id,
                       title: room.title,
                       description: room.description,
                       color: room.color,
                       startDate: "\(room.startDate[0])-\(room.startDate[1])-\(room.startDate[2])"))
    }
    return data
  }
}
