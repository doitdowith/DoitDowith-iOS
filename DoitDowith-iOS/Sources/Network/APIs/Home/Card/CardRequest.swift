//
//  CardRequest.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/12.
//

import Foundation
import Alamofire

struct CardRequest: RequestType {
  var memberId: String
  var endpoint: String = "/api/v1/room/"
  var method: HTTPMethod = .get
  var parameters: Parameters?
  var encoding: ParameterEncoding = JSONEncoding.default
  var headers: HTTPHeaders? = HTTPHeaders(["Content-Type": "application/json"])
  
  enum CodingKeys: String, CodingKey {
      case memberId
  }
  
  func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(memberId, forKey: .memberId)
  }
}
