//
//  CreateRoomRequest.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/17.
//

import Foundation
import Alamofire

struct CreateRoomRequest {
  var certificationCount: Int
  var color, description: String
  var participants: [String]
  var startDate, title: String
}
