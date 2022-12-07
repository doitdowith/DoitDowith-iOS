//
//  FriendResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/14.
//

import Foundation

struct FriendResponse: Decodable {
  var id: Int
  var data: [FriendData]
}

struct FriendData: Decodable {
  let id: Int
  let url: String
  let state: String
  let name: String
}

extension FriendResponse {
    var toDomain: [Friend] {
      return data.map { data in
        if data.state == "초대 가능" {
          return Friend(id: data.id, url: data.url, state: .success, name: data.name)
        } else {
          return Friend(id: data.id, url: data.url, state: .fail, name: data.name)
        }
      }
    }
}
