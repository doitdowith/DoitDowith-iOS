//
//  ChatModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import Foundation

import RealmSwift
import RxDataSources

struct ChatModel {
  var type: MessageType
  var profileImage: ImageType?
  var name: String
  var message: String?
  var image: ImageType?
  var time: String
}
