//
//  VoteMember.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/02.
//

import Foundation
import RxDataSources

enum VoteType {
  case all, good, bad
}
struct VoteMemberList: Equatable, IdentifiableType {
  var type: VoteType
  var data: [VoteMember]
  var identity: String
  
  init(type: VoteType, data: [VoteMember]) {
    self.type = type
    self.data = data
    self.identity = "\(Date.now.timeIntervalSinceReferenceDate)"
  }
}

struct VoteMember: Equatable {
  var type: Int
  var profileImageUrl: String?
  var nickName: String
  var emojiUrl: String?
}
