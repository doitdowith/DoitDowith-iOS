//
//  ChatModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import Foundation

import RealmSwift
import RxDataSources

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

enum Image {
  case base64(String)
  case url(String)
}

struct ChatModel {
  var type: MessageType
  var profileImage: Image?
  var name: String
  var message: String?
  var image: Image?
  var time: String
}
