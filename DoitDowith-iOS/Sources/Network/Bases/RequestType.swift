//
//  RequestType.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/17.
//

import Foundation
import Alamofire

struct RequestType {
  var endpoint: String
  var method: HTTPMethod
  var parameters: [String: Any]?
  var headers: [String: String] = ["Content-Type": "application/json"]
}
