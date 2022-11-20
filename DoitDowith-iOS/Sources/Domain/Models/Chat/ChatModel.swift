//
//  ChatModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import Foundation

import RxDataSources

enum MessageType {
  case receiveMessageWithProfile
  case receiveMessage
  case receiveImageMessage
  case sendMessageWithTip
  case sendMessage
  case sendImageMessage
}
struct ChatModel {
  var type: MessageType
  var memberId: Int
  var image: String
  var name: String
  var message: String
  var time: String
  
  init(type: MessageType, id: Int, image: String, name: String, message: String, time: String) {
    self.type = type
    self.memberId = id
    self.image = image
    self.name = name
    self.message = message
    self.time = time
  }
}
