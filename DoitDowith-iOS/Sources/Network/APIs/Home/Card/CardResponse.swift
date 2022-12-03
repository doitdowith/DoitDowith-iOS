//
//  CardResponse.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/12.
//

import Foundation

struct CardResponse: Decodable {
  var id: Int
  var data: [CardData]
}

struct CardData: Decodable {
  var section: Int
  var title: String
  var subTitle: String
}

extension CardResponse {
    var toDomain: [Card] {
      return data.map { data in
        return Card(section: data.section,
                    title: data.title,
                    subTitle: data.subTitle)
      }
    }
}
