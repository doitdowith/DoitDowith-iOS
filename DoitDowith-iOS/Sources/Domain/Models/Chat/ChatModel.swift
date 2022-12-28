//
//  ChatModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import Foundation

import RealmSwift
import RxDataSources

struct ChatModel: Equatable {
  var type: MessageType
  var profileImage: String
  var name: String
  var message: String
  var image: String?
  var time: String
}
