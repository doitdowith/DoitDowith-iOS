//
//  CertificateBoard.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/23.
//

import Foundation
import RxDataSources

enum PostType {
  case ImagePost
  case TextPost
}

struct CertificationPost: Equatable, IdentifiableType {
  var postType: PostType
  var profileImageUrl: String?
  var nickName: String
  var uploadTime: String
  var certificateImageUrl: String?
  var certificateText: String
  var identity: String
  
  init(postType: PostType,
       profileImageUrl: String? = nil,
       nickName: String,
       uploadTime: String,
       certificateImageUrl: String? = nil,
       certificateText: String) {
    self.postType = postType
    self.profileImageUrl = profileImageUrl
    self.nickName = nickName
    self.uploadTime = uploadTime
    self.certificateImageUrl = certificateImageUrl
    self.certificateText = certificateText
    self.identity = uploadTime
  }
}
