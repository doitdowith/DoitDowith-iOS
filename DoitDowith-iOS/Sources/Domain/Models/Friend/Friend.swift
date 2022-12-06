//
//  Friend.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/14.
//

import Foundation

enum State: String, Encodable {
  case success = "초대 가능"
  case fail = "이미 한 팀이에요"
  case ing = "초대중"
}
struct Friend: Encodable {
  let id: Int
  let url: String
  let state: State
  let name: String
}
