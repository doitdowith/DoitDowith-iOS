//
//  ChatResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/02.
//

import Foundation

import RxDataSources

struct ChatResponse: Codable {
  var data: [ChatData]
}

struct ChatData: Codable {
  var memberId: Int
  var image: String
  var name: String
  var message: String
  var time: String
}

extension ChatResponse {
  var toDomain: [ChatModel] {
    return data.map { data in
      let type: MessageType
      var currentMemberId = 0
      if data.memberId == 0 {
        if currentMemberId == data.memberId {
          type = .sendMessage
        } else {
          type = .sendMessageWithTip
          currentMemberId = data.memberId
        }
      } else {
        if currentMemberId == data.memberId {
          type = .receiveMessage
        } else {
          type = .receiveMessageWithProfile
          currentMemberId = data.memberId
        }
      }
      return ChatModel(type: type,
                       id: data.memberId,
                       image: data.image,
                       name: data.name,
                       message: data.message,
                       time: data.time)
    }
  }
}
