//
//  CardSectionModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/03.
//

import Foundation
import RxDataSources

enum CardSectionModel {
  case doing(items: [Card])
  case willdo(items: [Card])
  case done(items: [Card])
}

extension CardSectionModel: SectionModelType {
  typealias Item = Card
  
  var items: [Card] {
    switch self {
    case .doing(let items),
        .willdo(let items),
        .done(let items):
      return items
    }
  }
  
  init(original: Self, items: [Self.Item]) {
    self = original
  }
}
