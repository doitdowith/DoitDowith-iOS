//
//  CardModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import Foundation

struct CardModel: Codable {
  var section: Int
  var title: String
  var subTitle: String
  
  init(section: Int, title: String, subTitle: String) {
    self.section = section
    self.title = title
    self.subTitle = subTitle
  }
}
