//
//  StompTarget.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/17.
//

import Foundation

protocol StompTargetType {
  var path: String { get }
}

enum DestinationType {
  case receiveRoom(id: String)
  case sendRoom
}

extension DestinationType: StompTargetType {
  var path: String {
    switch self {
    case .receiveRoom(let id): return "/sub/room/\(id)"
    case .sendRoom: return "/pub/chat"
    }
  }
}
