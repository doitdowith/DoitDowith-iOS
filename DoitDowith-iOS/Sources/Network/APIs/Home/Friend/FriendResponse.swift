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
        return Friend(id: data.id, url: data.url, state: data.state, name: data.name)
      }
    }
}
