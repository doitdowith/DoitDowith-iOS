//
//  LoginResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/18.
//

import Foundation

struct LoginResponse: Decodable {
  var accessToken, email, memberId, name: String
  var profileImage, refreshToken: String
}
