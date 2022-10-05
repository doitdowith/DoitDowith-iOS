//
//  ChatModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import Foundation

import RxDataSources

struct ChatModel: Codable {
  var memberId: Int
  var name: String
  var message: String
  var time: String
  
  init(id: Int, name: String, message: String, time: String) {
    self.memberId = id
    self.name = name
    self.message = message
    self.time = time
  }
}
