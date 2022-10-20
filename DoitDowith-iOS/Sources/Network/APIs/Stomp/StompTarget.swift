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
  case receiveMemeber(id: String)
  case receiveRoom(id: Int)
  case sendRoom
}

extension DestinationType: StompTargetType {
  var path: String {
    switch self {
    case .receiveMemeber(let id): return "/sub/api/v1/member/\(id)"
    case .receiveRoom(let id): return "/sub/api/v1/room/\(id)"
    case .sendRoom: return "/pub/chat"
    }
  }
}
