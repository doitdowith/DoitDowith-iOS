//
//  MessageType.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/24.
//

import Foundation

enum MessageType: Int {
  case receiveMessageWithProfile = 0
  case receiveMessage = 1
  case receiveImageMessage = 2
  case sendMessageWithTip = 3
  case sendMessage = 4
  case sendImageMessage = 5
  case receiveImage = 6
  case sendImage = 7
}

extension MessageType {
  func inverseMessage() -> MessageType {
    switch self {
    case .sendMessage: return .sendMessageWithTip
    case .receiveMessage: return .receiveMessageWithProfile
    default: return self
    }
  }
}
