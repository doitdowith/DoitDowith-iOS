//
//  CardResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/12.
//

import Foundation

struct CardResponse: ResponseType {
  var statusCode: Int
  var doingRoomList, doneRoomList, willDoRoomList: [Room]
  var data: Data?
}

struct Room: Decodable {
    let color, roomListDescription, id, startDate: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case color
        case roomListDescription = "description"
        case id, startDate, title
    }
}

extension CardResponse {
    var toDomain: [Card] {
      var data: [Card] = []
      for room in doingRoomList {
        data.append(Card(section: 1,
                         roomId: room.id,
                         title: room.title,
                         description: room.roomListDescription,
                         color: room.color,
                         startDate: room.startDate))
      }
      for room in willDoRoomList {
        data.append(Card(section: 2,
                         roomId: room.id,
                         title: room.title,
                         description: room.roomListDescription,
                         color: room.color,
                         startDate: room.startDate))
      }
      for room in doneRoomList {
        data.append(Card(section: 3,
                         roomId: room.id,
                         title: room.title,
                         description: room.roomListDescription,
                         color: room.color,
                         startDate: room.startDate))
      }
     return data
    }
}
