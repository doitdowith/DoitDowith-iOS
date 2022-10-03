//
//  SectionOfCardModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import Foundation

import RxCocoa
import RxDataSources
import RxSwift

struct SectionOfCardModel {
  var header: String
  var items: [Item]
  
  init(header: String, items: [Item]) {
    self.header = header
    self.items = items
  }
}

extension SectionOfCardModel: SectionModelType {
  typealias Item = CardModel
  
  init(original: SectionOfCardModel, items: [CardModel]) {
    self = original
    self.items = items
  }
}
