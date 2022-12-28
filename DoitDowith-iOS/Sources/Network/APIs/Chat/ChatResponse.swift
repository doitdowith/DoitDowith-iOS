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
  var profileImage: String
  var name: String
  var contents: String
  var certificationImage: String?
  var time: String
  var me: Bool
}

extension ChatResponse {
  var toDomain: [ChatModel] {
    return data.map { data in
      let type: MessageType
      if data.me {
        if data.certificationImage != nil {
          type = .sendImageMessage
        } else {
          type = .sendMessage
        }
      } else {
        if data.certificationImage != nil {
          type = .receiveImageMessage
        } else {
          type = .receiveMessage
        }
      }
      return ChatModel(type: type,
                       profileImage: data.profileImage,
                       name: data.name,
                       message: data.contents,
                       image: data.certificationImage,
                       time: data.time)
    }
  }
}
