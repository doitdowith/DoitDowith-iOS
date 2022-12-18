//
//  CreateRoomRequest.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/17.
//

import Foundation
import Alamofire

struct CreateRoomRequest: RequestType {
  var endpoint: String = "/api/v1/room"
  var method: HTTPMethod = .post
  var parameters: Parameters?
  var encoding: ParameterEncoding = JSONEncoding.default
  
  var certificationCount: Int
  var color, description: String
  var participants: [String]
  var startDate, title: String
  
  enum CodingKeys: String, CodingKey {
    case certificationCount, color
    case participants, startDate, title
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.certificationCount, forKey: .certificationCount)
    try container.encode(self.color, forKey: .color)
    try container.encode(self.participants, forKey: .participants)
    try container.encode(self.startDate, forKey: .startDate)
    try container.encode(self.title, forKey: .title)
  }
}
