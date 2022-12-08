//
//  Card.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import Foundation
import RxDataSources

enum CardType: Int {
  case none = 0,
       doing = 1,
       willdo = 2,
       done = 3
}

struct CardList: Equatable, IdentifiableType {
  var type: CardType
  var data: [Card]
  var identity: String
  
  init(type: CardType, data: [Card]) {
    self.type = type
    self.data = data
    self.identity = "\(Date.now.timeIntervalSinceReferenceDate)"
  }
}

struct Card: Equatable, Codable {
  var section: Int
  var roomId: Int
  var title: String
  var description: String
}
