//
//  VoteMemberListResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/02.
//

import Foundation

struct VoteMemberListResponse: Decodable {
  var id: Int
  var data: [VoteMemberListData]
}

struct VoteMemberListData: Decodable {
  var type: Int
  var name: String
  var profileUrl: String?
  var imageUrl: String?
}

extension VoteMemberListResponse {
  var toDomain: [VoteMember] {
    return data.map { data in
      return VoteMember(
        type: data.type,
        profileImageUrl: data.profileUrl,
        nickName: data.name,
        emojiUrl: data.imageUrl)
    }
  }
}
