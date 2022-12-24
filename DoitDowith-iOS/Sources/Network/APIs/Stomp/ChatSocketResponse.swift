//
//  ChatSocketResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/24.
//

import Foundation

struct ChatSocketResponse: Codable {
  var contents: String
  var nickname: String
  var profileImg: String
  var sendTime: String
}

extension ChatSocketResponse {
  var toDomain: ChatModel {
    let baseurl = "http://117.17.198.38:8080/images"
    return ChatModel(type: .receiveMessage,
                      profileImage: .url("\(baseurl)/\(profileImg)"),
                      name: nickname,
                      message: contents,
                      time: "\(sendTime.substring(from: 0, to: 9)) \(sendTime.substring(from: 11, to: 15))")
  }
}
