//
//  MissionRoomRequest.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/20.
//

import Foundation

struct MissionRoomRequest: Encodable {
  let title: String
  let description: String
  let color: String
  let date: String
  let certificationCount: Int
  let members: [String]
}
