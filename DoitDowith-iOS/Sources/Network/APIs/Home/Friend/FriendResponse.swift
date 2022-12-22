//
//  FriendResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/14.
//

import Foundation

struct FriendResponse: Decodable {
  var data: [FriendData]
}

struct FriendData: Decodable {
  let name: String
  let memberId: String
  let profileImage: String
}

extension FriendResponse {
  var toDomain: [Friend] {
    return data.map { data in
      return Friend(id: data.memberId, url: data.profileImage, state: .can, name: data.name)
    }
  }
}
