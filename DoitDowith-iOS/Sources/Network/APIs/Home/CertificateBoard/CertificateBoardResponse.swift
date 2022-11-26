//
//  CertificateBoardResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/23.
//

import Foundation

struct CertificateBoardResponse: Decodable {
  var id: Int
  var data: [CertificateBoardData]
}

struct CertificateBoardData: Decodable {
  var name: String
  var time: Date
  var text: String
  var profileUrl: String?
  var imageUrl: String?
}

extension CertificateBoardResponse {
  var toDomain: [CertificationPost] {
    return data.map { data in
      var type: PostType = .ImagePost
      if data.imageUrl == nil {
        type = .TextPost
      }
      return CertificationPost(postType: type,
                               profileImageUrl: data.profileUrl,
                               nickName: data.name,
                               uploadTime: data.time,
                               certificateImageUrl: data.imageUrl,
                               certificateText: data.text)
    }
  }
}
