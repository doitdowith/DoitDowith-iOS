//
//  ChatModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import Foundation

import RxDataSources

enum ChatType: CaseIterable {
  case send
  case receive
}

struct ChatModel: Equatable, IdentifiableType {
  let type: ChatType
  let name: String
  let message: String
  let time: Date
  let identity: String
  
  init(type: ChatType, name: String, message: String, time: Date) {
    self.type = type
    self.name = name
    self.message = message
    self.time = time
    self.identity = "\(time.timeIntervalSinceReferenceDate)"
  }
  init(type: ChatType, name: String, message: String, time: Date, identity: String) {
    self.type = type
    self.name = name
    self.message = message
    self.time = time
    self.identity = identity
  }
}
